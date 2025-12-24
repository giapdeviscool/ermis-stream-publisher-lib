import HaishinKit
import AVFoundation

class ErmisStreamPublisherLib: HybridErmisStreamPublisherLibSpec {
  
  
  private let session = AVAudioSession.sharedInstance()
  private let connection : RTMPConnection
  public static var stream : RTMPStream?
  public static var rtmpUrl : String?
  public static var streamKey : String?
  override init() {
    self.connection = RTMPConnection()
    ErmisStreamPublisherLib.stream = RTMPStream(connection: connection)
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
    setupStream()
    ErmisStreamPublisherView.hkview?.attachStream(ErmisStreamPublisherLib.stream!)
    connection.connect(ErmisStreamPublisherLib.rtmpUrl!)
    ErmisStreamPublisherLib.stream?.publish(ErmisStreamPublisherLib.streamKey!)
    
  }
  
  func stopStream() throws {
    ErmisStreamPublisherLib.stream?.close()
    connection.close()
    ErmisStreamPublisherView.hkview?.attachStream(nil)
    ErmisStreamPublisherLib.stream = nil
    ErmisStreamPublisherLib.stream = RTMPStream(connection: connection)
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
