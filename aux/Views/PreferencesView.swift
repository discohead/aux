//
//  PreferencesView.swift
//  aux
//
//  Created by Jared McFarland on 3/16/26.
//

import SwiftUI
import AuxKit

struct PreferencesView: View {
    @State private var installPath = CLIInstaller.defaultInstallPath
    @State private var installStatus: InstallStatus = .unknown
    @State private var statusMessage = ""
    @State private var showEscalationAlert = false
    @State private var pendingAction: PendingAction?

    private enum InstallStatus {
        case unknown, correct, stale, notInstalled
    }

    private enum PendingAction {
        case install, uninstall
    }

    var body: some View {
        Form {
            Section("CLI Installation") {
                HStack {
                    Text("Install Path:")
                    TextField("Path", text: $installPath)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: installPath) { refreshStatus() }
                }

                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(statusText)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Button(installStatus == .notInstalled ? "Install CLI" : "Reinstall CLI") {
                        installCLI()
                    }

                    if installStatus == .correct || installStatus == .stale {
                        Button("Uninstall CLI") {
                            uninstallCLI()
                        }
                    }
                }

                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("About") {
                LabeledContent("Version", value: Aux.version)
            }
        }
        .padding()
        .frame(width: 400)
        .onAppear { refreshStatus() }
        .alert("Administrator Privileges Required", isPresented: $showEscalationAlert) {
            Button("OK") { performPrivilegedAction() }
            Button("Cancel", role: .cancel) {
                pendingAction = nil
                statusMessage = ""
            }
        } message: {
            Text("aux will now prompt with 'osascript' for Administrator privileges to \(pendingAction == .install ? "install" : "uninstall") the shell command.")
        }
    }

    private var statusColor: Color {
        switch installStatus {
        case .correct: return .green
        case .stale: return .yellow
        case .notInstalled, .unknown: return .red
        }
    }

    private var statusText: String {
        switch installStatus {
        case .correct: return "CLI installed"
        case .stale: return "CLI installed (pointing to different app)"
        case .notInstalled, .unknown: return "CLI not installed"
        }
    }

    private func refreshStatus() {
        if !CLIInstaller.isInstalled(at: installPath) {
            installStatus = .notInstalled
        } else if CLIInstaller.isCorrectlyInstalled(at: installPath) {
            installStatus = .correct
        } else {
            installStatus = .stale
        }
    }

    private func installCLI() {
        // Try direct install first (works if user has write permission)
        do {
            try CLIInstaller.install(at: installPath)
            refreshStatus()
            statusMessage = "CLI installed successfully at \(installPath)"
            return
        } catch {
            // Permission error — escalate via osascript
        }

        pendingAction = .install
        showEscalationAlert = true
    }

    private func uninstallCLI() {
        do {
            try CLIInstaller.uninstall(at: installPath)
            refreshStatus()
            statusMessage = "CLI uninstalled"
            return
        } catch {
            // Permission error — escalate via osascript
        }

        pendingAction = .uninstall
        showEscalationAlert = true
    }

    private func performPrivilegedAction() {
        guard let action = pendingAction else { return }
        pendingAction = nil

        Task {
            do {
                switch action {
                case .install:
                    try await CLIInstaller.installWithPrivileges(at: installPath)
                    statusMessage = "CLI installed successfully at \(installPath)"
                case .uninstall:
                    try await CLIInstaller.uninstallWithPrivileges(at: installPath)
                    statusMessage = "CLI uninstalled"
                }
                refreshStatus()
            } catch CLIInstaller.InstallError.userCancelled {
                statusMessage = ""
            } catch {
                statusMessage = "Failed: \(error.localizedDescription)"
            }
        }
    }
}
