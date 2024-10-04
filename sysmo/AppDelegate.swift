//
//  AppDelegate.swift
//  sysmo
//
//  Created by Yunus Melih Gözütok on 4.10.2024.
//

import Cocoa
import SwiftUI
import IOKit
import Darwin


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status item in the menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Set the initial title or icon for the menu bar item
        statusItem?.button?.title = "Sysmo..."

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
        var vmStat = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &vmStat) { (vmStatPtr) -> kern_return_t in
            vmStatPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            return -1 // Return -1 if unable to fetch memory stats
        }

        let pageSize = UInt64(vm_kernel_page_size)
        
        // Only consider active and wired memory as "used memory"
        let usedMemory = (UInt64(vmStat.active_count) + UInt64(vmStat.wire_count))
        let freeMemory = UInt64(vmStat.free_count)
        
        // Total memory is the sum of used and free memory
        let totalMemory = usedMemory + freeMemory

        let usagePercentage = (Double(usedMemory) / Double(totalMemory)) * 100
        return Int(usagePercentage)
    }



    func getCpuUsage() -> Int {
        // Implement CPU usage retrieval, use 10% as a placeholder
        // You may want to add a proper system call or use a library here.
        return 10
    }
}
