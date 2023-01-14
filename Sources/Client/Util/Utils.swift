import Foundation
import SwiftUI

enum Utils {
  #if os(macOS)
  /// Runs a shell command.
  static func shell(_ command: String) {
    let task = Process()
    task.arguments = ["-c", command]
    task.launchPath = "/bin/bash"
    task.launch()
  }
  
  /// Relaunches the application.
  static func relaunch() {
    log.info("Relaunching Delta Client")
    let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
    let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
    let task = Process()
    task.launchPath = "/usr/bin/open"
    task.arguments = [path]
    task.launch()
    exit(0)
  }
  #endif
}

extension Image {
    init(packageResource name: String, ofType type: String) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
        #else
        self.init(name)
        #endif
    }
}
