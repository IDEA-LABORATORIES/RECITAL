import MobileCoreServices
import UIKit

class AudioSelector: NSObject, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    var viewController: ControlPanelViewController!
    var sandboxFileURL: URL!
    var audioFileHasBeenSelected = false
    
    init(viewController: ControlPanelViewController) {
        self.viewController  = viewController
    }
    
    // https://www.youtube.com/watch?v=p1UNnsodJxc (Dont Work)
    // https://stackoverflow.com/questions/37296929/implement-document-picker-in-swift-ios (Do Work)
    // Present the DocumentPickerViewController to select audio file in files application.
    public func selectAudio() {
        /* https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
        */
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        viewController.present(documentPicker, animated: true, completion: nil)
    }
    
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        print("Selected File : \(selectedFileURL)")
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("This file has already been copied.")
        }
        else {
            
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                print("File Copied.")
            }
            catch {
                print("Error: \(error)")
            }
        }
        audioFileHasBeenSelected = true
    }

    internal func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        viewController.present(documentPicker, animated: true, completion: nil)
    }

    internal func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func getAudioSandboxURL () -> URL {
        return sandboxFileURL
    }
    
    public func getAudioFileHasBeenSelected() -> Bool {
        return audioFileHasBeenSelected
    }
}
