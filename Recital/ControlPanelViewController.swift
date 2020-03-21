import UIKit

class ControlPanelViewController: UIViewController {

    var audioSelector: AudioSelector!
    var audioKitEngine: AudioKitEngine!
    var playCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSelector = AudioSelector(viewController: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSelectAudio(_ sender: Any) {
        audioSelector.selectAudio()
    }
    
    // TODO: Disable button if audioSandboxFileURL is null.
    @IBAction func onPlay(_ sender: Any) {
        if (playCount == 0) {
            audioKitEngine = AudioKitEngine(audioSandboxFileURL: audioSelector.getAudioSandboxURL())
            playCount += 1
        }
        audioKitEngine.play()
    }
    
    @IBAction func onToggleLooping(_ sender: Any) {
        audioKitEngine.toggleLooping()
    }
}
