//
//  ControlPanelViewController.swift
//  Recital
//
//  Created by Asim Williams on 3/18/20.
//  Copyright © 2020 Asim Williams. All rights reserved.
//

import UIKit
import MobileCoreServices

class ControlPanelViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        print("Selected File : \(selectedFileURL)")
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
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
    }

    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    // https://www.youtube.com/watch?v=p1UNnsodJxc (Dont Work)
    // https://stackoverflow.com/questions/37296929/implement-document-picker-in-swift-ios (Do Work)
    // Present the DocumentPickerViewController to select audio file in files application.
    @IBAction func onSelectAudio(_ sender: Any) {
        /* https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
        */
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.mp3"], in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(documentPicker, animated: true, completion: nil)
    }
}
