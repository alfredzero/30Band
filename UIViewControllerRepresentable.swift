//
//  UIViewControllerRepresentable.swift
//  30BandEQUI
//
//  Created by Alfredo Amezcua on 8/19/24.
//

import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    var completion: (Result<URL, Error>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.completion(.success(url))
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle cancellation
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}
