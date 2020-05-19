import Foundation
import Stencil
import Path

/// The stencil filters to be used
public class StencilExtensions: Extension {
    private let filters: [StencilFilterInterface] = [
        StencilFilter.PathExists(),
        StencilFilter.RelativeToRoot(),
        StencilFilter.RelativeToModule(),
        StencilFilter.Absolut(),
        StencilFilter.ExpandDependencies()
    ]

    override init() {
        super.init()

        for filter in filters {
            registerFilter(type(of: filter).filterName, filter: filter.run)
        }
    }

    func set(_ context: Context.Middleware) {
        for filter in filters {
            filter.context = context
        }
    }
}
