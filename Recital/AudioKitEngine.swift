import AudioKit

class AudioKitEngine {
    // Declare audio playback node
    var player: AKPlayer!
    var audioSandboxFileURL: URL
    var selectedAudio: AKAudioFile!
    
    init(audioSandboxFileURL: URL) {
        self.audioSandboxFileURL = audioSandboxFileURL
    }
    
    public func play() {
        // If there is an audio file URL
        selectedAudio = try? AKAudioFile(forReading: URL(string: audioSandboxFileURL.absoluteString)!)
        player = AKPlayer(audioFile: selectedAudio)
        player.completionHandler = { AKLog("completion callback has been triggered!") }
        player.isLooping = true
        
        AudioKit.output = player
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start")
        }
        player.play()
    }
}
