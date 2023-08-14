import Foundation
import AVFoundation
import AVFAudio
import SwiftUI
import AppCore

struct AudioPlayerView: View {
    let audioUrl: String?
    @State var isPlaying = false
    
    private let model: AudioModel = AudioModel()
    
    var body: some View {
        if let audioUrl = audioUrl {
            Text.sfSymbol(isPlaying ? "pause.fill" : "speaker.wave.2")
                .frame(width: 25)
                .onTapGesture {
                    model.playSound(url: audioUrl)
                    isPlaying.toggle()
                    
                    if isPlaying {
                        model.audioPlayer?.play()
                    } else {
                        model.audioPlayer?.pause()
                    }
                }
        } else {
            Space(25, .h)
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
    
    // then lets create your document folder url
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // lets create your destination file url
    let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
    
    print(destinationUrl)
    
    // to check if it exists before downloading it
    if FileManager.default.fileExists(atPath: destinationUrl.path) {
        print("The file already exists at path")
    } else {
        
        // you can use NSURLSession.sharedSession to download the data asynchronously
        URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
            guard let location = location, error == nil else { return }
            do {
                // after downloading your file you need to move it to your destination url
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                print("File moved to documents folder")
            } catch {
                print(error)
            }
        }.resume()
    }
    
    return destinationUrl
}
