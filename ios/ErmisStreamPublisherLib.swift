import HaishinKit
import AVFoundation
import Logboard
import AVKit
import VideoToolbox
class ErmisStreamPublisherLib: HybridErmisStreamPublisherLibSpec {
  private let session = AVAudioSession.sharedInstance()
  private var connection = RTMPConnection()
  private var isConnected = false
  private var isSetupStream = true
  public static var stream : RTMPStream?
  public static var rtmpUrl : String?
  public static var streamKey : String?
  public static var videoBitrate: UInt32?
  public static var audioBitrate: Int?
  public static var frameRate: Double?
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
        settings.bitRate = ErmisStreamPublisherLib.videoBitrate!
        settings.videoSize = VideoSize(width: 1280, height: 720)
        ErmisStreamPublisherLib.stream?.videoSettings = settings
    }
      
    if let audioSettings = ErmisStreamPublisherLib.stream?.audioSettings {
        var settings = audioSettings
        settings.bitRate = ErmisStreamPublisherLib.audioBitrate!
        ErmisStreamPublisherLib.stream?.audioSettings = settings
    }
    ErmisStreamPublisherLib.stream?.frameRate = ErmisStreamPublisherLib.frameRate!
      
    print("Camera/Mic đã được cấu hình và kích hoạt thành công.")
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
    // Tạo connection MỚI - QUAN TRỌNG: RTMPConnection không thể reuse sau khi close
    if connection.connected == false {
      connection = RTMPConnection()
      connection.connect(ErmisStreamPublisherLib.rtmpUrl!)
    }
    
    ErmisStreamPublisherLib.stream = RTMPStream(connection: connection)
    //setup streaming
    setupStream()
    try? session.setActive(true)
    ErmisStreamPublisherView.hkview?.attachStream(ErmisStreamPublisherLib.stream!)
    
    ErmisStreamPublisherLib.stream?.publish(ErmisStreamPublisherLib.streamKey)
  }
  
  func stopStream() throws {
    ErmisStreamPublisherView.hkview?.attachStream(nil)
    Task {  // Đảm bảo chạy trên Main Thread để update UI an toàn
            print("Bắt đầu dừng stream...")

            guard let stream = ErmisStreamPublisherLib.stream else { return }

            // 1. Ngắt thiết bị (Video/Audio)
            stream.attachCamera(nil)
            stream.attachAudio(nil)

            // 4. Đóng connection (handler sẽ được gọi khi connection đóng)
            print("Đang đóng socket...")
            
            connection.close()
            
            // 5. Cleanup - không remove listener trong stopStream, để nó bắn event
            try? self.session.setActive(false)
            isSetupStream = false;
            print("Đã hoàn tất lệnh dừng.")
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
