//
//  SliderScrollView.swift
//  30BandEQUI
//
//  Created by Alfredo Amezcua on 8/19/24.
//

import SwiftUI

struct SlidersScrollView: View {
    @Binding var sliderValues: [Double]
    @ObservedObject var eqEngine: EqualizerEngine
    
    let frequencies = ["32 Hz", "64 Hz", "125 Hz", "250 Hz", "500 Hz", "1 kHz", "2 kHz", "4 kHz", "8 kHz", "16 kHz","20 Hz", "40 Hz", "80 Hz", "160 Hz", "320 Hz", "640 Hz", "1.28 kHz", "2.56 kHz", "5.12 kHz", "10.24 kHz","15 Hz", "30 Hz", "60 Hz", "120 Hz", "240 Hz", "480 Hz", "960 Hz", "1.92 kHz", "3.84 kHz", "7.68 kHz"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(0..<30, id: \.self) { index in
                    VerticalSlider(value: $sliderValues[index], bandIndex: index, eqEngine: eqEngine, frequency: frequencies[index])
                        .frame(width: 60, height: 900)  // Adjust frame size as needed
                }
            }
            .padding(.horizontal, 5)
        }
    }
}


@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
