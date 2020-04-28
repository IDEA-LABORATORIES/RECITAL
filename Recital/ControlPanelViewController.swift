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
    var pitchShiftOn: Bool = false
    var filterOn: Bool = false
    var loopingOn: Bool = true
    var lengthOfSong: String = ""

    // Outlets
    @IBOutlet weak var playbackPositionSlider: UISlider!
    @IBOutlet weak var playbackRateSlider: UISlider!
    
    @IBOutlet weak var pitchShiftKnob: Knob!
    @IBOutlet weak var pitchShiftOnOffButton: UIButton!
    
    @IBOutlet weak var filterOnOffButton: UIButton!
    @IBOutlet weak var bandpassCenterFreqKnob: Knob!
    @IBOutlet weak var bandpassBandwidthKnob: Knob!
    @IBOutlet weak var bandpassCenterFreqLabel: UILabel!
    @IBOutlet weak var bandpassBandwidthSliderLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var loopingOnOffButton: UIButton!
    
    @IBOutlet weak var currentPosInSong: UILabel!
    @IBOutlet weak var currentPlaybackRate: UILabel!
    
    @IBOutlet weak var noteFrequency: UILabel!
    @IBOutlet weak var noteNameWSharps: UILabel!
    @IBOutlet weak var noteNameWFlats: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "app_background.png")!)
        audioSelector = AudioSelector(viewController: self)
        // Do any additional setup after loading the view.
        playbackRateSlider.minimumValue = Float(0.25)
        playbackRateSlider.maximumValue = Float(2)
        playbackRateSlider.value = Float(1)
        
        // Filter & Pitch setup
        pitchShiftKnob.minimumValue = -2_400
        pitchShiftKnob.maximumValue = 2400
        pitchShiftKnob.setValue(0)
        pitchShiftKnob.lineWidth = 3
        pitchShiftKnob.pointerLength = 18
        
        bandpassCenterFreqKnob.minimumValue = Float(20)
        bandpassCenterFreqKnob.maximumValue = Float(10_000)
        bandpassBandwidthKnob.minimumValue = Float(100)
        bandpassBandwidthKnob.maximumValue = Float(1_200)
        bandpassCenterFreqKnob.lineWidth = 3
        bandpassCenterFreqKnob.pointerLength = 18
        bandpassBandwidthKnob.lineWidth = 3
        bandpassBandwidthKnob.pointerLength = 18
        
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
            disableUI()
        } else {
            // Initialize audioEngine
            audioKitEngine = AudioKitEngine(audioSandboxFileURL: audioSelector.getAudioSandboxURL())
            // Decide what happens when file reaches end and loop is off.
            audioKitEngine.getAudioPlayer().completionHandler = {
                self.audioKitEngine.getAudioPlayer().setPosition(0)
                self.playPauseToggle = 0
                self.playPauseButton.setTitle("Play", for: .normal)
            }
            
            enableUI()
            self.audioFileSelectedTimer.invalidate()
        }
    }
    
    func disableUI() {
        playbackPositionSlider.isEnabled = false
        playPauseButton.isEnabled = false
        loopingOnOffButton.isEnabled = false
        playbackRateSlider.isEnabled = false
        currentPosInSong.isEnabled = false
        currentPlaybackRate.isEnabled = false
        
        // Filter & Pitch
        pitchShiftOnOffButton.isEnabled = false
        pitchShiftKnob.isEnabled = false
        bandpassCenterFreqKnob.isEnabled = false
        bandpassCenterFreqLabel.isEnabled = false
        bandpassBandwidthKnob.isEnabled = false
        bandpassBandwidthSliderLabel.isEnabled = false
        filterOnOffButton.isEnabled = false
    }
    
    func enableUI() {
        playbackPositionSlider.isEnabled = true;
        playbackPositionSlider.maximumValue = Float(audioKitEngine.getAudioFileDuration())
        
        let totalMin = Int(playbackPositionSlider.maximumValue) / 60 % 60
        let totalSec = Int(playbackPositionSlider.maximumValue) % 60
        lengthOfSong = String(format:"%02i:%02i", totalMin, totalSec)
        
        playPauseButton.isEnabled = true
        loopingOnOffButton.isEnabled = true
        
        currentPosInSong.isEnabled = true
        currentPlaybackRate.isEnabled = true
        
        playbackRateSlider.isEnabled = true
        
        pitchShiftOnOffButton.isEnabled = true
        pitchShiftKnob.isEnabled = true
        bandpassCenterFreqKnob.isEnabled = true
        bandpassCenterFreqLabel.isEnabled = true
        bandpassBandwidthKnob.isEnabled = true
        bandpassBandwidthSliderLabel.isEnabled = true
        filterOnOffButton.isEnabled = true
        
        uiEnabled = true
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
    
    
    @IBAction func handleLoopingOnOff(_ sender: UIButton) {
        if (loopingOn) {
            audioKitEngine.toggleLooping(loop: false)
            loopingOn = false
        } else {
            audioKitEngine.toggleLooping(loop: true)
            loopingOn = true
        }
        
    }
    
    // Filter & Pitch
    @IBAction func handlePitchShiftOnOff(_ sender: UIButton) {
        if (pitchShiftOn) {
            audioKitEngine.turnPitchShiftOnOff(shifterOn: false)
            pitchShiftOn = false
        } else {
            audioKitEngine.turnPitchShiftOnOff(shifterOn: true)
            pitchShiftOn = true
        }
        
    }
    
    @IBAction func handlePitchShit(_ sender: Knob) {
        audioKitEngine.shiftPitch(value: Double(pitchShiftKnob.value))
    }
    
    @IBAction func changeBandpassCenterFreq(_ sender: Knob) {
        audioKitEngine.setBandpassFilterCenter(centerSliderPos: Double(bandpassCenterFreqKnob.value))
        updateFilterUI()
    }
    
    @IBAction func changeBandpassBandwidth(_ sender: Knob) {
        audioKitEngine.setBandPassFilterBandwidth(bandwidthSliderPos: Double(bandpassBandwidthKnob.value))
            updateFilterUI()
    }
    
    @IBAction func handleFilterOnOff(_ sender: Any) {
        if (filterOn) {
            audioKitEngine.toggleFilter(filterOn: false)
            filterOn = false
        } else {
            audioKitEngine.toggleFilter(filterOn: true)
            filterOn = true
        }
    }
    
    func updateFilterUI() {
        bandpassCenterFreqLabel.text = String(format: "Center Freq: %0.1f Hz", bandpassCenterFreqKnob.value)
        bandpassBandwidthSliderLabel.text = String(format: "Bandwidth: %0.1f Hz", bandpassBandwidthKnob.value)
    }
    
    // Audio Analysis
    func updateAudioAnalysisInfo() {
        let notes = audioKitEngine.determineNote()
        
        noteFrequency.text = String(format: "%0.1f", audioKitEngine.getFrequency())
        
        noteNameWSharps.text = notes[0]
        noteNameWFlats.text = notes[1]
    }
}
