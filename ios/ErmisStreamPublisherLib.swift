import HaishinKit
import AVFoundation

class ErmisStreamPublisherLib: HybridErmisStreamPublisherLibSpec {
  
  
  private let session = AVAudioSession.sharedInstance()
  private var connection : RTMPConnection?
  private var isConnected = false
  public static var stream : RTMPStream?
  public static var rtmpUrl : String?
  public static var streamKey : String?
  override init() {
    self.connection = RTMPConnection()
    ErmisStreamPublisherLib.stream = RTMPStream(connection: connection!)
    super.init()
    setupAudio()
  }
  private func setupStream() {
    ErmisStreamPublisherLib.stream!.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
      print(error)
    }
    ErmisStreamPublisherLib.stream!.attachCamera(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)) { error in
      print(error)
    }
    // Set video resolution to 1920x1080 (16:9)
    if let videoSettings = ErmisStreamPublisherLib.stream?.videoSettings {
      var settings = videoSettings
      settings.videoSize = VideoSize(width: 1920, height: 1080)
      ErmisStreamPublisherLib.stream?.videoSettings = settings
    }
    print("Camera đã được cấu hình và kích hoạt thành công.")
  }
  
  private func setupAudio() {
    do {
      try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP])
      try session.setActive(true)
      print("AVAudioSession đã được cấu hình và kích hoạt thành công.")
    } catch let error {
      print("Lỗi cấu hình hoặc kích hoạt AVAudioSession: \(error.localizedDescription)")
    }
  }
  
  
  func startStream() throws {
    // Tạo connection mới nếu cũ đã bị close
    connection = RTMPConnection()
    ErmisStreamPublisherLib.stream = RTMPStream(connection: connection!)
    setupStream()
    ErmisStreamPublisherView.hkview?.attachStream(ErmisStreamPublisherLib.stream!)
    
  
    connection?.connect(ErmisStreamPublisherLib.rtmpUrl!)
    ErmisStreamPublisherLib.stream?.publish(ErmisStreamPublisherLib.streamKey!)
    
  }
  
  func stopStream() throws {
      guard let stream = ErmisStreamPublisherLib.stream,
            let connection = self.connection else {
          print("Stream hoặc connection đã nil rồi")
          return
      }
      
      // 1. Detach preview trước
      ErmisStreamPublisherView.hkview?.attachStream(nil)
      
      // 2. Detach devices
      stream.attachCamera(nil)
      stream.attachAudio(nil)
      
      // 3. Unpublish stream (quan trọng!)
      stream.close()
      
      // 4. Đóng connection
      connection.close()
      
      // 5. Tắt audio session
      try? session.setActive(false, options: .notifyOthersOnDeactivation)
      
      // 6. Set nil
      ErmisStreamPublisherLib.stream = nil
      self.connection = nil
      
      print("Stream đã dừng hoàn toàn")
  }
  
  func flipCamera(position: Bool) throws {
    print("stream conencted ?: ",connection!.connected)
    if position == true {
      ErmisStreamPublisherLib.stream!.attachCamera(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)) { error in
        print(error)
      }
    } else {
      ErmisStreamPublisherLib.stream!.attachCamera(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)) { error in
        print(error)
      }
    }
  }
}
