import AudioKit

class AudioKitEngine {
    // Declare audio playback node
    var player: AKPlayer!
    
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
        player.completionHandler = { AKLog("completion callback has been triggered!") }
        
        player.isLooping = true
        // Sound that comes out speakers is set as player output.
        AudioKit.output = player
        
        
        
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
    
    public func toggleLooping(loop: Bool) {
        player.isLooping = loop
    }
    
    // Getters
    public func getAudioFileDuration() -> Double {
        return selectedAudio.duration
    }
    
    public func getCurrentPositionInAudio() -> Float {
        return Float(player.currentTime)
    }
}
