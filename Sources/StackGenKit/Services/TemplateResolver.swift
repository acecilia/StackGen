import Foundation
import Path
import Yams

/// The service in charge of resolving which templates file to use
public struct TemplatesFileResolver {
    private let availableTemplateGroups: [String: [TemplateSpec.Input]]
    private let env: Env

    public init(_ availableTemplateGroups: [String: [TemplateSpec.Input]] ,_ env: Env) {
        self.availableTemplateGroups = availableTemplateGroups
        self.env = env
    }

    public func resolve(_ templateGroups: [String]) throws -> [TemplateSpec.Input] {
        return try templateGroups.flatMap { templateGroup in
            try (
                availableTemplateGroups[templateGroup] ??
                BundledTemplateGroup.allCases.first { $0.rawValue == templateGroup }?.convert()
            )
            .unwrap(onFailure: .templateGroupNotFound(identifier: templateGroup))
        }
    }
}
