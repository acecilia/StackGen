import Foundation
import SwiftCLI

/// A base class used to share command line options among different commands
public class BaseCommand {
    @Key("-t", "--templates", description: "It can either be: a) an identifier of the templates to use, if they are part of the included templates, or b) the path pointing to the template file to use")
    var templates: String?
}
