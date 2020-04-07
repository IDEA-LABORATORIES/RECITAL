import UIKit

class ControlPanelViewController: UIViewController {

    var audioSelector: AudioSelector!
    var audioKitEngine: AudioKitEngine!
    
    var audioFileSelectedTimer: Timer!
    var updatePlaybackPositionSliderTimer: Timer!
    
    var uiEnabled = false
    var playPauseToggle: Int = 0
    var lengthOfSong: String = ""

    // Outlets
    @IBOutlet weak var playbackPositionSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var loopingToggle: UISwitch!
    @IBOutlet weak var currentPosInSong: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSelector = AudioSelector(viewController: self)
        // Do any additional setup after loading the view.
        
        // Check to see if user has selected an audio file
        audioFileSelectedTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            self.checkAudioFileSelected()
        })
        updatePlaybackPositionSliderTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            if (self.uiEnabled) {
                self.updatePlaybackPositionSlider()
            }
        })
    }
    
    // If audio file has not been selected disable UI
    func checkAudioFileSelected() {
        if (!audioSelector.getAudioFileHasBeenSelected()) {
            playbackPositionSlider.isEnabled = false
            playPauseButton.isEnabled = false
            loopingToggle.isEnabled = false
        } else {
            // Initialize audioEngine
            audioKitEngine = AudioKitEngine(audioSandboxFileURL: audioSelector.getAudioSandboxURL())
            // Decide what happens when file reaches end and loop is off.
            audioKitEngine.getAudioPlayer().completionHandler = {
                self.audioKitEngine.getAudioPlayer().setPosition(0)
                self.playPauseToggle = 0
                self.playPauseButton.setTitle("Play", for: .normal)
            }
            
            playbackPositionSlider.isEnabled = true;
            playbackPositionSlider.maximumValue = Float(audioKitEngine.getAudioFileDuration())
            
            let totalMin = Int(playbackPositionSlider.maximumValue) / 60 % 60
            let totalSec = Int(playbackPositionSlider.maximumValue) % 60
            lengthOfSong = String(format:"%02i:%02i", totalMin, totalSec)
            
            playPauseButton.isEnabled = true
            loopingToggle.isEnabled = true
            
            uiEnabled = true
            self.audioFileSelectedTimer.invalidate()
        }
    }
    
    @IBAction func onSelectAudio(_ sender: Any) {
        audioSelector.selectAudio()
    }
    
    @IBAction func setPlaybackPosition(_ sender: Any) {
        audioKitEngine.setPlaybackPosition(sliderPos: Double(playbackPositionSlider!.value), playPauseToggle: playPauseToggle)
    }
    
    public func updatePlaybackPositionSlider() {
        playbackPositionSlider.value = audioKitEngine.getCurrentPositionInAudio()
        let currMin = (Int(playbackPositionSlider.value) / 60) % 60
        let currSec = Int(playbackPositionSlider.value) % 60
        let currPIS = String(format:"%02i:%02i", currMin, currSec)
        
        currentPosInSong.text = currPIS + "/" + lengthOfSong
    }
    
    // TODO: Changing volume on simulator breaks play.
    @IBAction func onPlay(_ sender: UIButton) {
        if (playPauseToggle == 0) {
            audioKitEngine.play()
            playPauseToggle = 1;
            sender.setTitle("Pause", for: .normal)
        } else {
            audioKitEngine.pause(sliderPos: Double(playbackPositionSlider!.value))
            playPauseToggle = 0
            sender.setTitle("Play", for: .normal)
        }
    }
    
    // TODO: What todo when file reaches end and looping is off.
    @IBAction func onLoopingToggle(_ sender: UISwitch) {
        audioKitEngine.toggleLooping(loop: sender.isOn)
    }
}
