import AudioKit

class AudioKitEngine {
    // Declare audio playback node
    var player: AKPlayer!
    
    // Instance Variables
    var audioSandboxFileURL: URL
    var selectedAudio: AKAudioFile!
    var playCount: Int = 0
    
    init(audioSandboxFileURL: URL) {
        self.audioSandboxFileURL = audioSandboxFileURL
    }
    
    public func play() {
        // Its not even getting here the second time
        playCount += 1
        print("play: ", playCount)
        if (playCount > 1) {
            player.stop()
            do {
                try AudioKit.stop()
            } catch {
                AKLog("AudioKit did not stop")
            }
        }
        
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
        player.play()
    }
    
    public func toggleLooping() {
        print(player.isLooping)
        player.isLooping = !player.isLooping
    }
}
