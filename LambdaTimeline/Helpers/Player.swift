//
//  Player.swift
//  LambdaTimeline
//
//  Created by Alex Rhodes on 10/29/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol PlayerDelegate {
    func playerDidChangeState(player: Player)
}


// AVAudioPlayerDelegate requires a NSObject subclass
class Player: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    var delegate: PlayerDelegate?
    var url: URL?
    var timer: Timer?
    
    var timeElapsed: TimeInterval {
    //        return audioPlayer?.currentTime ?? 0.0
        audioPlayer?.currentTime ?? 0.0
    }

    var duration: TimeInterval {
        audioPlayer?.duration ?? 0.0
    }

    var timeRemaining: TimeInterval {
        duration - timeElapsed
    }
    
    
//    init(url: URL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!) {
//        self.url = url
//        
//        // create an audio player
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//        } catch {
//            print("AudioPlayer Error: \(url)")
//        }
//        
//        super.init()
//        
//        audioPlayer?.delegate = self
//    }
    
    // isPlaying
    // play
    // pause
    // playPause
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    func play() {
        // Option 1
//        if let audioPlayer = audioPlayer {
//            audioPlayer.play()
            // do other work here
//        }
        
        // Option 2
//        guard let audioPlayer = audioPlayer else {
//            print("Error: no player")
//            return
//        }
//
//        audioPlayer.play()
//      analytics.record("play")
        
        // Option 3: Optional chaining
        audioPlayer?.play()         // if nil, this is a no-op (no operation: i.e.: nothing happens)
        delegate?.playerDidChangeState(player: self)
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        delegate?.playerDidChangeState(player: self)
        cancelTimer()
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func updateTimer(timer: Timer) {
        delegate?.playerDidChangeState(player: self)
    }
    
    // FUTURE: seekToPosition: Double
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("AVAudioError: \(String(describing: error))")
        cancelTimer()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // send delegate message to update the UI
        delegate?.playerDidChangeState(player: self)
        cancelTimer()
    }
}
