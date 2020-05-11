import Foundation
import Stencil
import Path

public class CustomExtensions: Extension {
    private let filters: [Filter] = [
        PathExistsFilter(),
        RelativeToRootFilter(),
        RelativeToModuleFilter(),
        AbsolutFilter(),
        ExpandDependenciesFilter()
    ]

    override init() {
        super.init()

        for filter in filters {
            registerFilter(type(of: filter).filterName, filter: filter.run)
        }
    }

    func set(_ context: MainContext) {
        for filter in filters {
            filter.context = context
        }
    }
}
