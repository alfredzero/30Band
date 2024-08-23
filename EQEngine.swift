//
//  EQEngine.swift
//  30BandEQUI
//
//  Created by Alfredo Amezcua on 8/19/24.
//

import AVFoundation
import SwiftUI

class EqualizerEngine: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var audioPlayerNode = AVAudioPlayerNode()
    private var eqNode: AVAudioUnitEQ
    
    init() {
        eqNode = AVAudioUnitEQ(numberOfBands: 30)
        
        // Set up EQ bands
        let bands = eqNode.bands
        for (index, band) in bands.enumerated() {
            band.frequency = 100.0 * Float(index + 1) // Example frequencies
            band.bandwidth = 1.0
            band.bypass = false
        }
        
        // Attach nodes to engine
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(eqNode)
        audioEngine.connect(audioPlayerNode, to: eqNode, format: nil)
        audioEngine.connect(eqNode, to: audioEngine.mainMixerNode, format: nil)
        
        do {
            try audioEngine.start()
            print("Audio Engine started successfully.")
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    func loadAudioFile(_ url: URL) {
        do {
            let audioFile = try AVAudioFile(forReading: url)
            audioPlayerNode.stop()
            audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
            audioPlayerNode.play()
            print("Audio file loaded and playback started.")
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    func setEQBand(_ bandIndex: Int, gain: Float) {
        guard bandIndex >= 0 && bandIndex < eqNode.bands.count else { return }
        eqNode.bands[bandIndex].gain = gain
    }
}

