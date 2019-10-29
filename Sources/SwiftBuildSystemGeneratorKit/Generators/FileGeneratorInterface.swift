public protocol FileGeneratorInterface {
    static var outputFileName: String { get }
    func generate() throws
}
