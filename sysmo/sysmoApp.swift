//
//  Created by Yunus Melih Gözütok on 4.10.2024.
//

import SwiftUI

@main
struct SystemMonitorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            EmptyView() // We don't need a main window
        }
    }
}
