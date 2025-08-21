import Foundation

enum LogLevel: String, CaseIterable {
    case log = "LOG"
    case error = "ERROR"
    case warn = "WARN"
    case debug = "DEBUG"
    case verbose = "VERBOSE"
}

final class Logger {
    private let context: String?
    private let dateFormatter: DateFormatter

    init(context: String? = nil) {
        self.context = context
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }

    private func logMessage(_ level: LogLevel, _ message: String) {
        let timestamp = dateFormatter.string(from: Date())
        let ctxString = context.map { "[\($0)]" } ?? ""
        print("\(timestamp) \(level.rawValue) \(ctxString) - \(message)")
    }
    
    func log(_ message: String) {
        logMessage(.log, message)
    }

    func error(_ message: String, error: Error? = nil) {
        var fullMessage = message
        if let error = error {
            fullMessage += " | Error: \(error)"
        }
        logMessage(.error, fullMessage)
    }

    func warn(_ message: String) {
        logMessage(.warn, message)
    }

    func debug(_ message: String) {
        logMessage(.debug, message)
    }

    func verbose(_ message: String) {
        logMessage(.verbose, message)
    }

    // Static convenience methods without context
    static func log(_ message: String) {
        Logger().log(message)
    }

    static func error(_ message: String, error: Error? = nil) {
        Logger().error(message, error: error)
    }

    static func warn(_ message: String) {
        Logger().warn(message)
    }

    static func debug(_ message: String) {
        Logger().debug(message)
    }

    static func verbose(_ message: String) {
        Logger().verbose(message)
    }
}
