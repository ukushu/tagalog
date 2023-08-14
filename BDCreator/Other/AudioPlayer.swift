import Foundation
import AVFoundation
import AVFAudio
import SwiftUI
import AppCore

struct AudioPlayerView: View {
    let audioUrl: String?
    
    private let model: AudioModel = AudioModel()
    
    var body: some View {
        if let audioUrl = audioUrl {
            Text.sfSymbol("speaker.wave.2")
                //.frame(width: 35)
                .onTapGesture {
                    model.playSound(url: audioUrl)
                    
                    model.audioPlayer?.play()
                }
        } else {
            Space(34, .h)
        }
    }
}

fileprivate class AudioModel {
    var audioPlayer : AVAudioPlayer?
    
    func playSound(url: String) {
        let localMp3 = downloadMp3(from: url)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: localMp3)
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
        }
    }
}

fileprivate func downloadMp3(from url: String) -> URL {
    let audioUrl = URL(string: url)!
    
    let destinationUrl = URL.BDCreateHome.appendingPathComponent(audioUrl.lastPathComponent)
    
    guard !FileManager.default.fileExists(atPath: destinationUrl.path) else { return destinationUrl }
    
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = [ "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" ]
    
    let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    
    let semaphore = DispatchSemaphore(value: 1)
    
    // you can use NSURLSession.sharedSession to download the data asynchronously
    session.downloadTask(with: audioUrl) { location, response, error in
        guard let location = location, error == nil else { return }
        do {
            // after downloading your file you need to move it to your destination url
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("File moved to documents folder")
        } catch {
            print(error)
        }
        
        semaphore.signal()
    }.resume()
    
    semaphore.wait()
    
    return destinationUrl
}
