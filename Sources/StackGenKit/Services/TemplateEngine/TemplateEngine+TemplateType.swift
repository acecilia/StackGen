import Foundation

extension TemplateEngine {
    /// The supported template types
    public enum TemplateType {
        public static let stencilTemplateDelimiters = ["{%", "{{"]

        case stencil
        case plainText

        /// Detect the template kind. The first delimiter that appears will determine which kind it is
        public init(_ template: Template) throws {
            let templateContent = try template.content()
            if Self.stencilTemplateDelimiters.contains(where: templateContent.contains) {
                self = .stencil
            } else {
                self = .plainText
            }
        }
    }

}
