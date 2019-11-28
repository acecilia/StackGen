import Foundation

public protocol ReporterInterface {
    func start(_ arguments: [String])
    func info(_ string: String)
    func warning(_ string: String)
    func formatAsError(_ string: String) -> String
    func end(_ status: Int32)
}
