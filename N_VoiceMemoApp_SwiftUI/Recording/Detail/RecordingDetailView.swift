//
//  RecordingDetailView.swift
//  N_VoiceMemoApp_SwiftUI
//
//  Created by wodnd on 6/5/25.
//

import SwiftUI
import AVFoundation

struct RecordingDetailView: View {
    let recording: recording?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    @State private var timer: Timer?

    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if let recordingTitle = recording?.title {
                    Text(recordingTitle)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.bk)
                        .padding(.top, Constants.ControlHeight * 39)
                        .padding(.leading, Constants.ControlWidth * 30)
                }
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                if let recordingDate = recording?.date {
                    Text(recordingDate)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.key)
                        .padding(.top, Constants.ControlHeight * 20)
                        .padding(.leading, Constants.ControlWidth * 30)
                }
                
                Spacer()
            }
            
            if let recordingTime = recording?.time {
                let totalSeconds = timeStringToSeconds(recordingTime)
                ProgressView(value: currentTime, total: totalSeconds)
                    .accentColor(.black)
                    .padding(.horizontal, Constants.ControlWidth * 30)
                    .padding(.top, Constants.ControlHeight * 30)
            }
            
            
            
            HStack(spacing: 0) {
                if let recordingTime = recording?.time {
                    Text(formatTime(currentTime))
                        .font(.system(size: 14))
                        .foregroundColor(.iconOn)
                    
                    Spacer()
                    
                    Text(recordingTime)
                        .font(.system(size: 14))
                        .foregroundColor(.iconOn)
                }
            }
            .padding(.top, Constants.ControlHeight * 10)
            .padding(.leading, Constants.ControlWidth * 30)
            .padding(.trailing, Constants.ControlWidth * 30)
            
            ZStack{
                HStack(spacing: 0) {
                    Button {
                        audioPlayer?.currentTime = 0
                        audioPlayer?.play()
                    } label: {
                        Image(systemName: "backward.end.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.ControlWidth * 30)
                            .foregroundColor(.bk)
                    }
                    .padding(.leading, Constants.ControlWidth * 100)
                    
                    Spacer()
                }
                
                Button {
                    if isPlaying {
                            audioPlayer?.pause()
                            isPlaying = false
                        } else {
                            guard let fileName = recording?.id else { return }
                            playRecording(fileName: fileName)
                        }
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.ControlWidth * 30)
                        .foregroundColor(.bk)
                }
            }
            
            Spacer()
        }
    }
    
    func playRecording(fileName: String) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(fileName).m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            startTimer()
        } catch {
            print("재생 실패: \(error.localizedDescription)")
        }
    }
    
    func timeStringToSeconds(_ timeString: String) -> Double {
        let components = timeString.split(separator: ":").map { Double($0) ?? 0 }
        if components.count == 2 {
            return components[0] * 60 + components[1]
        }
        return 0
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer() {
        timer?.invalidate()
        
        guard let recordingTime = recording?.time else { return }
        let totalSeconds = timeStringToSeconds(recordingTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let player = audioPlayer, player.isPlaying {
                currentTime = player.currentTime
                
                if currentTime >= totalSeconds {
                    isPlaying = false
                    stopTimer()
                    currentTime = 0
                    audioPlayer?.stop()
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    RecordingDetailView(recording: recording(id: "", title: "안녕", time: "00:30", date: "날짜"))
}
