import HaishinKit
import AVFoundation

class ErmisStreamPublisherLib: HybridErmisStreamPublisherLibSpec {
  
  
  private let session = AVAudioSession.sharedInstance()
  private var connection : RTMPConnection?
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
    // Detach preview và dừng session của view
    ErmisStreamPublisherView.hkview?.attachStream(nil)
    // Detach camera và mic để giải phóng thiết bị
    ErmisStreamPublisherLib.stream?.attachCamera(nil)
    ErmisStreamPublisherLib.stream?.attachAudio(nil)
    // Đóng stream và connection
    ErmisStreamPublisherLib.stream?.close()
    connection?.close()
    // Tuỳ chọn: tắt AVAudioSession nếu muốn nhả route audio hoàn toàn
    try? session.setActive(false, options: .notifyOthersOnDeactivation)
    // Xoá stream hiện tại, connection sẽ được tạo mới khi gọi startStream lần tiếp theo
    ErmisStreamPublisherLib.stream = nil
    connection = nil
  }
  
  func flipCamera(position: Bool) throws {
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
