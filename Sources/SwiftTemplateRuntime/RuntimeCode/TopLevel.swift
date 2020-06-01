import Foundation
import Path

public let context: Context.Output = {
    do {
        let contextData = try Data(contentsOf: Path(ProcessInfo().arguments[1])!)
        return try JSONDecoder().decode(Context.Output.self, from: contextData)
    } catch {
        fatalError("\(error)")
    }
}()

public let env = context.env
public let global = context.global
public let modules = context.modules
public let module = context.module
