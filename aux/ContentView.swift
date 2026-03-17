//
//  ContentView.swift
//  aux
//
//  Created by Jared McFarland on 3/15/26.
//

import SwiftUI
import MusicKit
import AuxKit

struct ContentView: View {
    @State private var authStatus: MusicAuthorization.Status = MusicAuthorization.currentStatus
    @State private var isAuthorizing = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "music.note")
                .font(.system(size: 64))
                .foregroundStyle(.tint)

            Text("Aux")
                .font(.largeTitle.bold())

            Text("Apple Music CLI & App")
                .font(.title3)
                .foregroundStyle(.secondary)

            Divider()
                .frame(width: 200)

            // Auth status
            HStack(spacing: 8) {
                Circle()
                    .fill(authStatus == .authorized ? .green : .orange)
                    .frame(width: 10, height: 10)
                Text(authStatusText)
                    .font(.callout)
            }

            if authStatus != .authorized {
                Button("Authorize Apple Music") {
                    Task {
                        isAuthorizing = true
                        let status = await MusicAuthorization.request()
                        authStatus = status
                        isAuthorizing = false
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isAuthorizing)
            }

            Text("v\(Aux.version)")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(40)
        .frame(minWidth: 300, minHeight: 300)
        .onAppear {
            authStatus = MusicAuthorization.currentStatus
        }
    }

    private var authStatusText: String {
        switch authStatus {
        case .authorized: "Authorized"
        case .denied: "Access Denied"
        case .notDetermined: "Not Yet Authorized"
        case .restricted: "Restricted"
        @unknown default: "Unknown"
        }
    }
}

#Preview {
    ContentView()
}
