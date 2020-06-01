import Foundation
import Path

public let context: Context.Middleware = {
    do {
        let contextData = try Data(contentsOf: Path(ProcessInfo().arguments[1])!)
        return try JSONDecoder().decode(Context.Middleware.self, from: contextData)
    } catch {
        fatalError("\(error)")
    }
}()

public let env = context.output.env
public let global = context.output.global
public let firstPartyModules = context.firstPartyModules
public let thirdPartyModules = context.thirdPartyModules
public let module = context.output.module
