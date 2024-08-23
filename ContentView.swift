//
//  ContentView.swift
//  30BandEQUI
//
//  Created by Alfredo Amezcua on 8/19/24.
//

import SwiftUI
import AVFoundation
import MusicKit
import MediaPlayer

struct ContentView: View {
    @State private var sliderValues = Array(repeating: 0.0, count: 30)
    @ObservedObject var eqEngine = EqualizerEngine()
    @State private var isShowingDocumentPicker = false
    @State private var importedURL: URL?
    @State private var musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    var body: some View {
        VStack(spacing: 20) {
            // VStack for Sliders Scroll View
            VStack {
                SlidersScrollView(sliderValues: $sliderValues, eqEngine: eqEngine)
                    .frame(height: 400)
                    .padding(.horizontal)
                
                Spacer() // Push the button to the bottom
            }
            
            // VStack for Upload Button at the bottom
            VStack {
                Button(action: {
                    isShowingDocumentPicker = true
                }, label: {
                    Text("Upload Audio")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                .padding()
                
                Button(action: playAppleMusic, label: {
                    Text("Play Apple Music")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                .padding()
            }
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker { result in
                switch result {
                case .success(let url):
                    importedURL = url
                    eqEngine.loadAudioFile(url)
                    applyEQSettings()
                case .failure(let error):
                    print("Failed to import file: \(error.localizedDescription)")
                }
            }
        }
        .padding()
        .onAppear {
            requestMusicAuthorization()
        }
    }
    
    private func requestMusicAuthorization() {
        Task {
            do {
                let status = try await MusicAuthorization.request()
                if status == .authorized {
                    print("MusicKit authorized")
                } else {
                    print("MusicKit not authorized")
                }
            } catch {
                print("Failed to request authorization: \(error.localizedDescription)")
            }
        }
    }

    private func playAppleMusic() {
        let query = MPMediaQuery.songs()
        guard let songs = query.items else {
            print("No songs found")
            return
        }
        
        // Set the queue with an array of MPMediaItems
        musicPlayer.setQueue(with: MPMediaItemCollection(items: songs))
        musicPlayer.play()
    }

    private func applyEQSettings() {
        for (index, value) in sliderValues.enumerated() {
            let gain = Float(value)
            eqEngine.setEQBand(index, gain: gain)
        }
    }
}
