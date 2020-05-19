/// A protocol that specifies a common API for an action.
/// An action contains the code to be called when a subcommand is executed from the
/// command line
public protocol Action {
    func execute() throws
}
