//
//  File.swift
//  My App
//
//  Created by Felipe on 18/02/25.
//

import Foundation
import AVFoundation

@Observable
class AudioManager {
    static let shared = AudioManager()
    
    var audioPlayer: AVAudioPlayer?
    var backgroundAudioPlayer: AVAudioPlayer?
    
    var isPlaying = false
    var volume: Float = 0.7 {
        didSet {
            audioPlayer?.volume = volume
        }
    }
    
    private init() {
        setupAudioPlayer()
        setupBackgroundLoopMusic()
    }
    
    private func setupBackgroundLoopMusic() {
        guard let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") else {
            return
        }
        
        do {
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundAudioPlayer?.numberOfLoops = -1 // Reprodução contínua
            backgroundAudioPlayer?.volume = 0.15
        } catch {
            print("Erro ao carregar o arquivo de áudio: \(error.localizedDescription)")
        }
    }
    
    private func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "zicoBarking", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
        } catch {
            print("Erro ao carregar o arquivo de áudio: \(error.localizedDescription)")
        }
    }
    
    func toggleAudio() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    func playAudio() {
        if isPlaying {
            return
        }
        isPlaying = true
        audioPlayer?.play()
        return
    }
    
    func playOnce() {
        audioPlayer?.play()
    }
    
    func stopAllAudio() {
        audioPlayer?.stop()
        isPlaying = false
        backgroundAudioPlayer?.play()
    }
    
    func restartAudio() {
        backgroundAudioPlayer?.play()
    }
}

func playPureTone(frequencyInHz: Int, amplitude: Float, durationInMillis: Int, completion: @escaping ()->Void) {
    //Use a semaphore to block until the tone completes playing
    let semaphore = DispatchSemaphore(value: 1)
    let completionBlock = completion
    //Run async in the background so as not to block the current thread
    DispatchQueue.global().async {
        //Build the player and its engine
        let audioPlayer = AVAudioPlayerNode()
        let audioEngine = AVAudioEngine()
        semaphore.wait()//Claim the semphore for blocking
        audioEngine.attach(audioPlayer)
        let mixer = audioEngine.mainMixerNode
        let sampleRateHz = Float(mixer.outputFormat(forBus: 0).sampleRate)
        
        guard let format = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatFloat32, sampleRate: Double(sampleRateHz), channels: AVAudioChannelCount(1), interleaved: false) else {
            return
        }
        // Connect the audio engine to the audio player
        audioEngine.connect(audioPlayer, to: mixer, format: format)
        
        
        let numberOfSamples = AVAudioFrameCount((Float(durationInMillis) / 1000 * sampleRateHz))
        //create the appropriatly sized buffer
        guard let buffer  = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: numberOfSamples) else {
            return
        }
        buffer.frameLength = numberOfSamples
        //get a pointer to the buffer of floats
        let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(format.channelCount))
        let floats = UnsafeMutableBufferPointer<Float>(start: channels[0], count: Int(numberOfSamples))
        //calculate the angular frequency
        let angularFrequency = Float(frequencyInHz * 2) * .pi
        // Generate and store the sequential samples representing the sine wave of the tone
        for i in 0 ..< Int(numberOfSamples) {
            let waveComponent = sinf(Float(i) * angularFrequency / sampleRateHz)
            floats[i] = waveComponent * amplitude
        }
        do {
            try audioEngine.start()
        }
        catch{
            print("Error: Engine start failure")
            return
        }

        // Play the pure tone represented by the buffer
        audioPlayer.play()
        audioPlayer.scheduleBuffer(buffer, at: nil, options: .interrupts){
            DispatchQueue.main.async {
                completionBlock()
                semaphore.signal()//Release one claim of the semiphore
            }
        }
        semaphore.wait()//Wait for the semiphore so the function doesn't end before the playing of the tone completes
        semaphore.signal()//Release the other claim of the semiphore
    }
}

func hitButton(){
    playPureTone(frequencyInHz: 230, amplitude: 1.0, durationInMillis: 150, completion: {() in ()})
}

func diselectButton(){
    playPureTone(frequencyInHz: 150, amplitude: 1.5, durationInMillis: 150, completion: {() in ()})
}
