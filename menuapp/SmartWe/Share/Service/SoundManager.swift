//
//  SoundManager.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/04/17.
//

import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    func playSound(soundFileName: String) {
        guard let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav") else { return }

        let url = URL(fileURLWithPath: bundlePath)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.stop() // Ensure stopping previous sound
            audioPlayer?.play()
        } catch {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}
