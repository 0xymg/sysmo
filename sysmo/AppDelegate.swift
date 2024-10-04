//
//  AppDelegate.swift
//  sysmo
//
//  Created by Yunus Melih Gözütok on 4.10.2024.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status item in the menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Set the initial title or icon for the menu bar item
        statusItem?.button?.title = "Loading..."

        // Set up a menu for additional options
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem?.menu = menu
        
        // Start updating CPU and memory usage
        updateSystemUsage()
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    func updateSystemUsage() {
        // Set up a repeating timer to update every 2 seconds
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.statusItem?.button?.title = self.getSystemUsageInfo()
        }
    }

    func getSystemUsageInfo() -> String {
        // Use the `ProcessInfo` for memory usage
        let memoryUsage = getMemoryUsage()
        // CPU usage can be captured using a third-party library or a system call
        let cpuUsage = getCpuUsage()
        
        return "CPU: \(cpuUsage)%  Mem: \(memoryUsage)%"
    }

    func getMemoryUsage() -> Int {
        let usedMemory = ProcessInfo.processInfo.physicalMemory
        // Convert to percentage (rough calculation)
        let totalMemory = Double(ProcessInfo.processInfo.physicalMemory)
        let usagePercentage = (Double(usedMemory) / totalMemory) * 100
        return Int(usagePercentage)
    }

    func getCpuUsage() -> Int {
        // Implement CPU usage retrieval, use 10% as a placeholder
        // You may want to add a proper system call or use a library here.
        return 10
    }
}
