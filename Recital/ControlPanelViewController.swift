import UIKit

class ControlPanelViewController: UIViewController {

    var audioSelector: AudioSelector!
    var audioKitEngine: AudioKitEngine!
//    var playCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSelector = AudioSelector(viewController: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSelectAudio(_ sender: Any) {
        audioSelector.selectAudio()
    }
    
    // TODO: Disable button if audioSandboxFileURL is null.
    // TODO: Changing volume on simulator breaks play.
    var playPauseToggle: Int = 0
    var playerStarted: Int = 0
    @IBAction func onPlay(_ sender: UIButton) {
        if (playPauseToggle == 0) {
            if (playerStarted == 0) {
                audioKitEngine = AudioKitEngine(audioSandboxFileURL: audioSelector.getAudioSandboxURL())
                playerStarted = 1
            }
            audioKitEngine.play()
            playPauseToggle = 1;
            sender.setTitle("Pause", for: .normal)
        } else {
            audioKitEngine.pause()
            playPauseToggle = 0
            sender.setTitle("Play", for: .normal)
        }
    }
    
    @IBAction func onToggleLooping(_ sender: Any) {
        audioKitEngine.toggleLooping()
    }
}
