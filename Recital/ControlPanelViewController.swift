import UIKit

class ControlPanelViewController: UIViewController {

    var audioSelector: AudioSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSelector = AudioSelector()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSelectAudio(_ sender: Any) {
        audioSelector.setViewController(self)
        audioSelector.selectAudio()
    }
}
