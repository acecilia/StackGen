import UIKit
import SwiftModule1
import SwiftModule3

class MainViewController: UIViewController {
    let moduleName = "App"
    let module1Name = SwiftModule1.moduleName
    let module2Name = SwiftModule1.module2Name
    let snapKitName = SwiftModule1.snapKitName
    let module3Name = SwiftModule3.moduleName

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .red
    }
}
