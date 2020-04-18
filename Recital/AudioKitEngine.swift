import AudioKit

class AudioKitEngine {
    // Declare audio playback node
    var player: AKPlayer!
    // Declare Time and Pitch node
    var timeAndPitchManipulator: AKTimePitch!
    // Declare Frequency Tracking node
    var frequencyTracker: AKFrequencyTracker!
    
    // Instance Variables
    var audioSandboxFileURL: URL
    var selectedAudio: AKAudioFile!
    
    // Called in ControlPanelViewController.
    init(audioSandboxFileURL: URL) {
        self.audioSandboxFileURL = audioSandboxFileURL
        // https://github.com/AudioKit/AudioKit/issues/1073
        // If there is an audio file URL create an audio kit file from it.
        selectedAudio = try? AKAudioFile(forReading: URL(string: audioSandboxFileURL.absoluteString)!)
        guard selectedAudio != nil else {
            print("can't play file")
            return
        }
        
        // AudioKitPlayer node uses audio file as input.
        player = AKPlayer(audioFile: selectedAudio)
        
        player.isLooping = true
        
        // Output from player node (audioplayer) is input for time and pitch maniplator node
        timeAndPitchManipulator = AKTimePitch(player)
        
        // Output form time and pitch maniplator node is input for frequency tracking node
        frequencyTracker = AKFrequencyTracker(timeAndPitchManipulator)
        
        // Sound that comes out speakers is set as timeAndPitchManipulator output.
        AudioKit.output = frequencyTracker
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start")
        }
    }
    
    public func play() {
        player.play()
    }
    
    // Pause
    public func pause(sliderPos: Double) {
        player.stop()
        player.setPosition(sliderPos)
    }
    
    // Set Playback Postion (Scrub)
    public func setPlaybackPosition(sliderPos: Double, playPauseToggle: Int) {
        if (player.isPlaying) {
            player.stop()
        }
        player.setPosition(sliderPos)
        player.prepare()
        if (playPauseToggle == 1) {
            player.play()
        }
    }
    
    public func setPlaybackRate(sliderPos: Double) {
        timeAndPitchManipulator.rate = sliderPos
    }
    
    public func toggleLooping(loop: Bool) {
        player.isLooping = loop
    }
    
//------------------------------------- Audio Analysis Start ------------------------------
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    public func getFrequency() -> Float {
        return Float(frequencyTracker.frequency)
    }
    
    public func determineNote() -> Array<String> {
        let trackerFrequency = Float(frequencyTracker.frequency)
        var frequency = trackerFrequency
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies[0]) {
            frequency *= 2.0
        }

        var minDistance: Float = 10_000.0
        var index = 0

        for i in 0..<noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[i]) - frequency)
            if distance < minDistance {
                index = i
                minDistance = distance
            }
        }
        let octave = Int(log2f(trackerFrequency / frequency))
        let notes = ["\(noteNamesWithSharps[index])\(octave)", "\(noteNamesWithSharps[index])\(octave)"]
        return notes
    }
//------------------------------------- Audio Analysis End --------------------------------
    
    // Getters
    public func getAudioFileDuration() -> Double {
        return selectedAudio.duration
    }
    
    public func getCurrentPositionInAudio() -> Float {
        return Float(player.currentTime)
    }
    
    // probably not great encaspulation... but works for now.
    public func getAudioPlayer() -> AKPlayer {
        return player
    }
}
