import HaishinKit
import AVFoundation
import Logboard
import AVKit
import VideoToolbox
class ErmisStreamPublisherLib: HybridErmisStreamPublisherLibSpec {
  
  
  private let session = AVAudioSession.sharedInstance()
  private var connection = RTMPConnection()
  private var isConnected = false
  public static var stream : RTMPStream?
  public static var rtmpUrl : String?
  public static var streamKey : String?
  override init() {
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
    // Remove listener cũ nếu có
    connection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
    
    // Tạo connection MỚI - QUAN TRỌNG: RTMPConnection không thể reuse sau khi close
    if connection.connected == false {
      connection = RTMPConnection()
      connection.connect(ErmisStreamPublisherLib.rtmpUrl!)
    }
    
    ErmisStreamPublisherLib.stream = RTMPStream(connection: connection)
    
    connection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
    setupStream()
    ErmisStreamPublisherView.hkview?.attachStream(ErmisStreamPublisherLib.stream!)
    
    ErmisStreamPublisherLib.stream?.publish(ErmisStreamPublisherLib.streamKey)
  }
  
  func stopStream() throws {
    ErmisStreamPublisherView.hkview?.attachStream(nil)
    Task {  // Đảm bảo chạy trên Main Thread để update UI an toàn
            print("🛑 Bắt đầu dừng stream...")

            guard let stream = ErmisStreamPublisherLib.stream else { return }

            // 1. Ngắt thiết bị (Video/Audio)
            stream.attachCamera(nil)
            stream.attachAudio(nil)

            // 3. Delay để event listener kịp bắn
            try? await Task.sleep(nanoseconds: 200 * 1_000_000)

            // 4. Đóng connection (handler sẽ được gọi khi connection đóng)
            print("Đang đóng socket...")
            
     
            connection.close()
            
            // 5. Cleanup - không remove listener trong stopStream, để nó bắn event
            try? self.session.setActive(false)
            
            print("✅ Đã hoàn tất lệnh dừng.")
        }
    
  }
  
  @objc private func rtmpStatusHandler(_ notification: Notification) {
      print("📢 rtmpStatusHandler called")
      let e = Event.from(notification)
      guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
          print("⚠️ Cannot extract data or code from event")
          return
      }
      
      print("📡 Received code: \(code)")
      
      // Kiểm tra code
      switch code {
      case RTMPConnection.Code.connectClosed.rawValue:
          print("🔴 Đã ngắt kết nối (Log: NetConnection.Connect.Closed)")
          // Emit event to React Native
      case RTMPConnection.Code.connectSuccess.rawValue:
          print("🟢 Kết nối thành công")
          // Emit success event to React Native
      default:
          print(code)
          // Check if it's a connection error
          if code.contains("error") || code.contains("Error") || code.contains("failed") {
            
          }
          break
      }
  }
  
  func flipCamera(position: Bool) throws {
    print("stream conencted ?: ",connection.connected)
    ErmisStreamPublisherLib.stream?.send(handlerName: "DeleteStream", arguments: "please delete Stream")

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
