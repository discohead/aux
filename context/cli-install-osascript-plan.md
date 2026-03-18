# Plan: VS Code-style CLI Installation with osascript Privilege Escalation

## Context

The `aux` app has a "Install CLI" feature in Preferences that creates a symlink at `/usr/local/bin/aux` → the app's executable. This currently fails silently because `/usr/local/bin` requires admin privileges, falling back to showing a manual `sudo` command for the user to copy/paste into Terminal. VS Code solves this elegantly using `osascript` with `do shell script ... with administrator privileges`, which triggers a native macOS password dialog. We'll adopt the same approach.

## Files to Modify

| File | Change |
|------|--------|
| `AuxKit/App/CLIInstaller.swift` | Add osascript-based privileged install/uninstall, symlink validation |
| `aux/Views/PreferencesView.swift` | Add confirmation dialog before privilege escalation, update flow |
| `AuxKitTests/App/CLIInstallerTests.swift` | Add tests for new validation and command-building logic |

## Implementation

### 1. Update `CLIInstaller.swift`

**a. Add symlink validation (like VS Code's check-before-install):**
- New method `isCorrectlyInstalled(at:)` that checks if the path is a symlink pointing to the correct target (not just "file exists")
- Use `FileManager.destinationOfSymbolicLink(atPath:)` to verify the target matches `appExecutablePath()`

**b. Add privileged install via osascript:**
- New async method `installWithPrivileges(at:)` that:
  1. Builds the shell command: `mkdir -p /usr/local/bin && ln -sf '<execPath>' '<installPath>'`
  2. Wraps it in: `osascript -e "do shell script \"<cmd>\" with administrator privileges"`
  3. Executes via `Process` and captures exit code/stderr
  4. Throws descriptive errors on failure (including user cancellation)
- New error case: `userCancelled` for when user dismisses the osascript dialog

**c. Add privileged uninstall via osascript:**
- New async method `uninstallWithPrivileges(at:)` using same osascript pattern
- Command: `rm -f '<installPath>'`

**d. Update `install()` flow:**
- Try direct symlink creation first (works if user has permissions)
- If that fails with permission error, call `installWithPrivileges(at:)`
- This makes it seamless — no admin prompt if not needed

### 2. Update `PreferencesView.swift`

**a. Replace manual-command fallback with osascript flow:**
- Remove `showManualInstall` state and manual command display
- On "Install CLI" button press:
  1. Try direct install first
  2. If permission error → show confirmation alert (like VS Code: "aux will now prompt for Administrator privileges...")
  3. On confirm → call `CLIInstaller.installWithPrivileges(at:)`
  4. On cancel → do nothing
- Same pattern for uninstall

**b. Use `isCorrectlyInstalled(at:)` for status indicator:**
- Green dot = symlink exists AND points to correct target
- Yellow dot = symlink exists but points to wrong target (stale install)
- Red dot = not installed

**c. Add `@State` for alert presentation and async task management**

### 3. Update `CLIInstallerTests.swift`

- Test `isCorrectlyInstalled()` returns false for nonexistent path
- Test `isCorrectlyInstalled()` returns false for regular file (not symlink)
- Test `isCorrectlyInstalled()` returns true for correct symlink (in temp dir)
- Test `isCorrectlyInstalled()` returns false for symlink pointing to wrong target
- Test shell command string building (extract command builder as internal method for testability)
- Test `userCancelled` error case exists

## Key Design Decisions

- **Try unprivileged first, escalate on failure** — matches VS Code behavior and avoids unnecessary admin prompts
- **Confirmation dialog before osascript** — VS Code shows a warning before triggering the system password dialog; we should too
- **No separate shell script** — VS Code uses a bash wrapper because it needs to resolve the `.app` path from a symlink. `aux` is simpler: the symlink points directly to the Mach-O binary inside the `.app` bundle, which already handles dual-mode detection. No wrapper script needed.
- **Async methods** — `Process` execution should be async to avoid blocking the UI

## Verification

1. Build the app: `xcodebuildmcp macos build --scheme aux --project aux.xcodeproj`
2. Run tests: `xcodebuildmcp macos test --scheme AuxKit --project aux.xcodeproj`
3. Manual test: Launch aux.app → Preferences → Install CLI → verify macOS password dialog appears → verify `/usr/local/bin/aux` symlink is created correctly
4. Manual test: Verify `aux --help` works from a new terminal session after install

## VS Code Reference

The approach is modeled after VS Code's `installShellCommand()` in `src/vs/platform/native/electron-main/nativeHostMainService.ts`. Key differences:
- VS Code uses a bash wrapper script (`resources/darwin/bin/code.sh`) that resolves the `.app` path from symlinks. We don't need this because `aux` is a dual-mode binary — the symlink points directly to the Mach-O executable.
- VS Code's wrapper runs Electron in Node.js mode (`ELECTRON_RUN_AS_NODE=1`). Our binary already detects CLI vs GUI mode via `LaunchModeDetector`.
- The osascript privilege escalation pattern is identical.
