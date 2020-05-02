import UIKit
import DSWaveformImage

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
    
    //Playback
    var currMin: Int!
    var currSec: Int!

    // Outlets
    //Playback
    @IBOutlet weak var waveformScrollView: UIScrollView!
    @IBOutlet weak var waveformImageView: UIImageView!
    
    @IBOutlet weak var playbackPositionSlider: UISlider!
    @IBOutlet var playbackRateSliderView: UIView!
    let customPlaybackRateSlider = CustomSlider(frame: .zero)
    
    //Pitch and Filter
    @IBOutlet weak var pitchShiftKnob: Knob!
    @IBOutlet weak var pitchShiftOnOffButton: UIButton!
    
    @IBOutlet weak var filterOnOffButton: UIButton!
    @IBOutlet weak var bandpassCenterFreqKnob: Knob!
    @IBOutlet weak var bandpassBandwidthKnob: Knob!
    @IBOutlet weak var bandpassCenterFreqLabel: UILabel!
    @IBOutlet weak var bandpassBandwidthSliderLabel: UILabel!
    
    // Playback
    @IBOutlet weak var setLoopPointAButton: UIButton!
    @IBOutlet weak var loopPointALabel: UILabel!
    @IBOutlet weak var setLoopPointBButton: UIButton!
    @IBOutlet weak var loopPointBLabel: UILabel!
    @IBOutlet weak var resetLoopPointsButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var loopingOnOffButton: UIButton!
    
    @IBOutlet weak var currentPosInSong: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var currentPlaybackRate: UILabel!
    
    // Audio Analysis
    @IBOutlet weak var noteFrequency: UILabel!
    @IBOutlet weak var noteNameWSharps: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "app_background.png")!)
        audioSelector = AudioSelector(viewController: self)
        playbackPositionSlider.setThumbImage(#imageLiteral(resourceName: "playback_slider_thumb"), for: .normal)
        setupPlaybackRateSlider()
        setupFilterAndPitch()
        
        // Timers
        // Check to see if user has selected an audio file
        audioFileSelectedTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            self.checkAudioFileSelected()
        })
        updateSlidersTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            if (self.uiEnabled) {
                // Playback
                self.currMin = (Int(self.playbackPositionSlider.value) / 60) % 60
                self.currSec = Int(self.playbackPositionSlider.value) % 60
                self.updatePlaybackPositionSlider()
                self.update_waveform_pos()
                self.currentPlaybackRate.text = String(format:"speed: %.02fx", self.customPlaybackRateSlider.thumbValue * 2)
            }
        })
        updateAudioAnalysisUI = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            if(self.uiEnabled) {
                self.updateAudioAnalysisInfo()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        let width = 382
      let height: CGFloat = 68
      
        customPlaybackRateSlider.frame = CGRect(x: 0, y: 614, width: width, height: Int(height))
        customPlaybackRateSlider.center = playbackRateSliderView.center
    }
    
    // File Selection
    // If audio file has not been selected disable UI
    func checkAudioFileSelected() {
        if (!audioSelector.getAudioFileHasBeenSelected()) {
            disableUI()
        } else {
            // Audio Waveform
            drawWaveform()
            
            // Initialize audioEngine
            initializeAudioEngine()
            
            enableUI()
            self.audioFileSelectedTimer.invalidate()
        }
    }
    
    // https://github.com/dmrschmidt/DSWaveformImage
    func drawWaveform() {
        let audioURL = audioSelector.getAudioSandboxURL()
        
        // Waveform image drawer (takes ~15 seconds)
        let waveformImageDrawer = WaveformImageDrawer()
        waveformImageDrawer.waveformImage(fromAudioAt: audioURL,
                                          size: waveformImageView.bounds.size,
                                          color: .white,
                                          style: .striped,
                                          position: .middle) { image in
            // need to jump back to main queue
            DispatchQueue.main.async {
                self.waveformImageView.image = image
            }
        }
    }
    
    // Moves waveform to the left
    func update_waveform_pos() {
        let unitsPerSecond = (waveformImageView.frame.width/CGFloat(audioKitEngine.getAudioFileDuration()))
        let waveform_x_transform = -1 * (waveformScrollView.center.x - (CGFloat(playbackPositionSlider.value) * unitsPerSecond))
        waveformScrollView.setContentOffset(CGPoint(x: waveform_x_transform, y: 0), animated: false)
    }
    
    func initializeAudioEngine() {
        audioKitEngine = AudioKitEngine(audioSandboxFileURL: audioSelector.getAudioSandboxURL())
        // Decide what happens when file reaches end and loop is off.
        audioKitEngine.getAudioPlayer().completionHandler = {
            self.audioKitEngine.getAudioPlayer().setPosition(0)
            self.playPauseToggle = 0
            self.playPauseButton.setTitle("Play", for: .normal)
        }
    }
    
    func disableUI() {
        playbackPositionSlider.isEnabled = false
        playPauseButton.isEnabled = false
        loopingOnOffButton.isEnabled = false
        customPlaybackRateSlider.isEnabled = false
        currentPosInSong.isEnabled = false
        currentPlaybackRate.isEnabled = false
        
        setLoopPointAButton.isEnabled = false
        loopPointALabel.isEnabled = false
        setLoopPointBButton.isEnabled = false
        loopPointBLabel.isEnabled = false
        resetLoopPointsButton.isEnabled = false
        
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
        songDurationLabel.text = lengthOfSong
        
        playPauseButton.isEnabled = true
        loopingOnOffButton.isEnabled = true
        
        currentPosInSong.isEnabled = true
        currentPlaybackRate.isEnabled = true
        
        customPlaybackRateSlider.isEnabled = true
        
        setLoopPointAButton.isEnabled = true
        loopPointALabel.isEnabled = true
        setLoopPointBButton.isEnabled = true
        loopPointBLabel.isEnabled = true
        resetLoopPointsButton.isEnabled = true
        loopPointBLabel.text = lengthOfSong
        
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
        currentPosInSong.text = String(format:"%02i:%02i", currMin, currSec)
    }
    
    @IBAction func handleLoopPointA(_ sender: UIButton) {
        audioKitEngine.setLoopPointA(posInAudio: Double(playbackPositionSlider!.value))
        loopPointALabel.text = String(format:"%02i:%02i", currMin, currSec)
    }
    
    @IBAction func handleLoopPointB(_ sender: UIButton) {
        audioKitEngine.setLoopPointB(posInAudio: Double(playbackPositionSlider!.value))
        loopPointBLabel.text = String(format:"%02i:%02i", currMin, currSec)
    }
    
    @IBAction func handleResetLoopPoints(_ sender: UIButton) {
        audioKitEngine.setLoopPointA(posInAudio: 0.0)
        loopPointALabel.text = "0:00"
        audioKitEngine.setLoopPointB(posInAudio: audioKitEngine.getAudioFileDuration())
        loopPointBLabel.text = lengthOfSong
    }
    
    func setupPlaybackRateSlider() {
        // The actual playback rate = thumbValue * 2 (TODO)
        customPlaybackRateSlider.thumbValue = 0.5
        customPlaybackRateSlider.addTarget(self, action: #selector(customPlaybackRateSliderValueChanged(_:)),
        for: .valueChanged)
        view.addSubview(customPlaybackRateSlider)
    }
    
    // Im pretty sure every other IOS app that changes audio playback rate does exactly the same thing.
    // It sounds exactly the same as transcribe (IOS app)
    @objc func customPlaybackRateSliderValueChanged(_ customSlider: CustomSlider) {
        audioKitEngine.setPlaybackRate(sliderPos: Double((customSlider.thumbValue) * 2))
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
    func setupFilterAndPitch() {
        pitchShiftKnob.minimumValue = -2_400
        pitchShiftKnob.maximumValue = 2400
        pitchShiftKnob.setValue(0)
        pitchShiftKnob.lineWidth = 4
        pitchShiftKnob.pointerLength = 18
        
        bandpassCenterFreqKnob.minimumValue = Float(20)
        bandpassCenterFreqKnob.maximumValue = Float(10_000)
        bandpassBandwidthKnob.minimumValue = Float(100)
        bandpassBandwidthKnob.maximumValue = Float(1_200)
        bandpassCenterFreqKnob.lineWidth = 4
        bandpassCenterFreqKnob.pointerLength = 18
        bandpassBandwidthKnob.lineWidth = 4
        bandpassBandwidthKnob.pointerLength = 18
    }
    
    @IBAction func handlePitchShiftOnOff(_ sender: UIButton) {
        if (pitchShiftOn) {
            audioKitEngine.turnPitchShiftOnOff(shifterOn: false)
            pitchShiftOn = false
            sender.setImage(UIImage(named: "power_btn_off.png")!, for: .normal)
        } else {
            audioKitEngine.turnPitchShiftOnOff(shifterOn: true)
            pitchShiftOn = true
            sender.setImage(UIImage(named: "power_btn_on.png")!, for: .normal)
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
    
    @IBAction func handleFilterOnOff(_ sender: UIButton) {
        if (filterOn) {
            audioKitEngine.toggleFilter(filterOn: false)
            filterOn = false
            sender.setImage(UIImage(named: "power_btn_off.png")!, for: .normal)
        } else {
            audioKitEngine.toggleFilter(filterOn: true)
            filterOn = true
            sender.setImage(UIImage(named: "power_btn_on.png")!, for: .normal)
        }
    }
    
    func updateFilterUI() {
        bandpassCenterFreqLabel.text = String(format: "Center Freq: %0.1f Hz", bandpassCenterFreqKnob.value)
        bandpassBandwidthSliderLabel.text = String(format: "Bandwidth: %0.1f Hz", bandpassBandwidthKnob.value)
    }
    
    // Audio Analysis
    func updateAudioAnalysisInfo() {
        let notes = audioKitEngine.determineNote()
        
        noteFrequency.text = String(format: "Frequency: %0.2fHz", audioKitEngine.getFrequency())
        
        noteNameWSharps.text = notes[0]
    }
}
