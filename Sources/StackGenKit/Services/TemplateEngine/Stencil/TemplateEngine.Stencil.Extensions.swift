import Foundation
import Stencil
import Path

extension TemplateEngine.Stencil {
    /// The stencil filters to be used
    public class Extensions: Extension {
        private let filters: [StencilFilterInterface] = [
            Filter.PathExists(),
            Filter.RelativeToRoot(),
            Filter.RelativeToModule(),
            Filter.Absolut(),
            Filter.Basename(),
            Filter.Parent(),
            Filter.ExpandDependencies()
        ]

        override init() {
            super.init()

            for filter in filters {
                registerFilter(type(of: filter).filterName, filter: filter.run)
            }
        }

        func set(_ context: Context.Output) {
            for filter in filters {
                filter.context = context
            }
        }
    }
}
