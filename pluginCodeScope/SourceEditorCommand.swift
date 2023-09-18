import Foundation
import XcodeKit
import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        print("Hello, world")
        
        do {
            let terminalOutput = try runTerminal(scriptName: "command")
            print("Terminal output:")
            print(terminalOutput)
        } catch {
            print("Failed to execute terminal command: \(error.localizedDescription)")
        }
        
        completionHandler(nil)
    }

    func runTerminal(scriptName: String) throws -> String {
        guard let scriptPath = Bundle.main.path(forResource: scriptName, ofType: "sh") else {
            throw NSError(domain: "com.example.MyApp", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to find script in app bundle"])
        }

        let task = Process()
        task.executableURL = URL(fileURLWithPath: scriptPath)
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        try task.run()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "com.example.MyApp", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to convert data to string"])
        }
        
        return output
    }
}
