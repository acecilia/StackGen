import XCTest
import Path

enum Snapshot {
    static var recording = false

    static func assert(_ left: Path, _ right: Path, _ message: String = "") {
        if recording {
            try! right.parent.mkdir(.p)
            try! left.copy(to: right)
        } else {
            let result = FileManager.default.contentsEqual(
                atPath: left.string,
                andPath: right.string
            )
            XCTAssertTrue(result, message)
        }
    }
}
