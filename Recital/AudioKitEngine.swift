import AudioKit

class AudioKitEngine {
    // Declare audio playback node
    var player: AKPlayer!
    
    // Instance Variables
    var audioSandboxFileURL: URL
    var selectedAudio: AKAudioFile!
    var playCount: Int = 0
    
    // Called in ControlPanelViewController.
    init(audioSandboxFileURL: URL) {
        self.audioSandboxFileURL = audioSandboxFileURL
    }
    
    var playerStarted: Int = 0
    public func play() {
        // TODO: Initialize player stuff somewhere between file being selected and play button being pressed for the first time.
        if (playerStarted == 0) {
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
            playerStarted = 1
        }
        
        if (player.isPaused) {
            player.play(from: player.pauseTime!)
        } else {
            player.play()
        }
    }
    
    // Pause
    public func pause() {
        if (player.isPlaying) {
            player.pause()
        }
    }
    
    // Scrubbing: Look at playingPositionSlider
    
    public func toggleLooping() {
        print(player.isLooping)
        player.isLooping = !player.isLooping
    }
}
