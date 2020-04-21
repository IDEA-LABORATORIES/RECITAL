import UIKit

class ControlPanelViewController: UIViewController {

    var audioSelector: AudioSelector!
    var audioKitEngine: AudioKitEngine!
    
    var audioFileSelectedTimer: Timer!
    var updateSlidersTimer: Timer!
    var updateAudioAnalysisUI: Timer!
    var updateFilterUITimer: Timer!
    
    var uiEnabled = false
    var playPauseToggle: Int = 0
    var lengthOfSong: String = ""

    // Outlets
    @IBOutlet weak var playbackPositionSlider: UISlider!
    @IBOutlet weak var playbackRateSlider: UISlider!
    
    @IBOutlet weak var bandpassCenterFreqSlider: UISlider!
    @IBOutlet weak var bandpassBandwidthSlider: UISlider!
    
    @IBOutlet weak var bandpassCenterFreqLabel: UILabel!
    @IBOutlet weak var bandpassBandwidthSliderLabel: UILabel!
    @IBOutlet weak var bandpassFilterToggle: UISwitch!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var loopingToggle: UISwitch!
    
    @IBOutlet weak var currentPosInSong: UILabel!
    @IBOutlet weak var currentPlaybackRate: UILabel!
    
    @IBOutlet weak var noteFrequency: UILabel!
    @IBOutlet weak var noteNameWSharps: UILabel!
    @IBOutlet weak var noteNameWFlats: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSelector = AudioSelector(viewController: self)
        // Do any additional setup after loading the view.
        playbackRateSlider.minimumValue = Float(0.25)
        playbackRateSlider.maximumValue = Float(2)
        playbackRateSlider.value = Float(1)
        
        // Filter setup
        bandpassCenterFreqSlider.minimumValue = Float(20)
        bandpassCenterFreqSlider.maximumValue = Float(10_000)
        bandpassBandwidthSlider.minimumValue = Float(100)
        bandpassBandwidthSlider.maximumValue = Float(1_200)
        bandpassFilterToggle.isOn = false
        
        // Check to see if user has selected an audio file
        audioFileSelectedTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            self.checkAudioFileSelected()
        })
        updateSlidersTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            if (self.uiEnabled) {
                // Playback
                self.updatePlaybackPositionSlider()
                self.currentPlaybackRate.text = String(format:"Playback Rate: %.02f", self.playbackRateSlider.value)
            }
        })
        updateFilterUITimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            if(self.uiEnabled) {
                self.updateFilterUI()
            }
        })
        updateAudioAnalysisUI = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            if(self.uiEnabled) {
                self.updateAudioAnalysisInfo()
            }
        })
    }
    
    // File Selection
    // If audio file has not been selected disable UI
    func checkAudioFileSelected() {
        if (!audioSelector.getAudioFileHasBeenSelected()) {
            playbackPositionSlider.isEnabled = false
            playPauseButton.isEnabled = false
            loopingToggle.isEnabled = false
            playbackRateSlider.isEnabled = false
            currentPosInSong.isEnabled = false
            currentPlaybackRate.isEnabled = false
            bandpassCenterFreqSlider.isEnabled = false
            bandpassCenterFreqLabel.isEnabled = false
            bandpassBandwidthSlider.isEnabled = false
            bandpassBandwidthSliderLabel.isEnabled = false
            bandpassFilterToggle.isEnabled = false
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
            
            currentPosInSong.isEnabled = true
            currentPlaybackRate.isEnabled = true
            
            playbackRateSlider.isEnabled = true
            
            bandpassCenterFreqSlider.isEnabled = true
            bandpassCenterFreqLabel.isEnabled = true
            bandpassBandwidthSlider.isEnabled = true
            bandpassBandwidthSliderLabel.isEnabled = true
            bandpassFilterToggle.isEnabled = true
            
            uiEnabled = true
            self.audioFileSelectedTimer.invalidate()
        }
    }
    
    @IBAction func onSelectAudio(_ sender: Any) {
        audioSelector.selectAudio()
    }
    
    // Playback
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
    
    // Im pretty sure every other IOS app that changes audio playback rate does exactly the same thing.
    // It sounds exactly the same as transcribe (IOS app)
    @IBAction func setPlaybackRate(_ sender: Any) {
        audioKitEngine.setPlaybackRate(sliderPos: Double(playbackRateSlider.value))
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
    
    @IBAction func onLoopingToggle(_ sender: UISwitch) {
        audioKitEngine.toggleLooping(loop: sender.isOn)
    }
    
    // Filter
    @IBAction func setBandpassCenterFreq(_ sender: Any) {
        audioKitEngine.setBandpassFilterCenter(centerSliderPos: Double(bandpassCenterFreqSlider.value))
    }
    
    @IBAction func setBandpassBandwidth(_ sender: Any) {
        audioKitEngine.setBandPassFilterBandwidth(bandwidthSliderPos: Double(bandpassBandwidthSlider.value))
    }
    
    @IBAction func onFilterToggle(_ sender: UISwitch) {
        audioKitEngine.toggleFilter(filter: sender.isOn)
    }
    
    func updateFilterUI() {
        bandpassCenterFreqLabel.text = String(format: "Center Freq: %0.1f Hz", bandpassCenterFreqSlider.value)
        bandpassBandwidthSliderLabel.text = String(format: "Bandwidth: %0.1f Hz", bandpassBandwidthSlider.value)
    }
    
    // Audio Analysis
    func updateAudioAnalysisInfo() {
        let notes = audioKitEngine.determineNote()
        
        noteFrequency.text = String(format: "%0.1f", audioKitEngine.getFrequency())
        
        noteNameWSharps.text = notes[0]
        noteNameWFlats.text = notes[1]
    }
}
