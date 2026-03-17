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
    @State private var isInstalled = CLIInstaller.isInstalled()
    @State private var statusMessage = ""

    var body: some View {
        Form {
            Section("CLI Installation") {
                HStack {
                    Text("Install Path:")
                    TextField("Path", text: $installPath)
                        .textFieldStyle(.roundedBorder)
                }

                HStack {
                    Circle()
                        .fill(isInstalled ? .green : .red)
                        .frame(width: 8, height: 8)
                    Text(isInstalled ? "CLI installed" : "CLI not installed")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Button(isInstalled ? "Reinstall CLI" : "Install CLI") {
                        installCLI()
                    }

                    if isInstalled {
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

                if showManualInstall {
                    HStack {
                        Text(manualInstallCommand)
                            .font(.system(.caption, design: .monospaced))
                            .textSelection(.enabled)
                            .padding(6)
                            .background(Color(nsColor: .textBackgroundColor))
                            .cornerRadius(4)

                        Button {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(manualInstallCommand, forType: .string)
                            statusMessage = "Copied to clipboard! Paste in Terminal and run."
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(.borderless)
                        .help("Copy to clipboard")
                    }
                }
            }

            Section("About") {
                LabeledContent("Version", value: Aux.version)
            }
        }
        .padding()
        .frame(width: 400)
    }

    @State private var showManualInstall = false

    private var manualInstallCommand: String {
        "sudo ln -sf /Applications/aux.app/Contents/MacOS/aux \(installPath)"
    }

    private func installCLI() {
        do {
            try CLIInstaller.install(at: installPath)
            isInstalled = true
            showManualInstall = false
            statusMessage = "CLI installed successfully at \(installPath)"
        } catch {
            showManualInstall = true
            statusMessage = "Requires elevated permissions. Run this in Terminal:"
        }
    }

    private func uninstallCLI() {
        do {
            try CLIInstaller.uninstall(at: installPath)
            isInstalled = false
            statusMessage = "CLI uninstalled"
        } catch {
            statusMessage = "Uninstall failed: \(error.localizedDescription)"
        }
    }
}
