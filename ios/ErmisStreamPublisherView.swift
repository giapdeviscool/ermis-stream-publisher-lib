//
//  ErmisStreamPublisherView.swift
//  ErmisStreamPublisherLib
//
//  Created by Giáp Phan Văn on 17/12/25.
//

import Foundation
import UIKit
import HaishinKit
import AVFoundation
import VideoToolbox
class ErmisStreamPublisherView : HybridErmisStreamPublisherViewSpec {
      var view = UIView()
      public static var hkview : MTHKView?
      var rtmpUrl: String = "" {
        didSet {
          ErmisStreamPublisherLib.rtmpUrl = rtmpUrl
        }
      }
      var streamKey: String = "" {
        didSet {
          ErmisStreamPublisherLib.streamKey = streamKey
        }
      }
  
      var frameRate: Double? = 0 {
        didSet {
          ErmisStreamPublisherLib.stream?.frameRate = frameRate!
        }
      }
      
      var audioBitrate: Double? = 0 {
        didSet {
          ErmisStreamPublisherLib.stream?.audioSettings.bitRate = Int(audioBitrate!)
        }
      }
      
      var videoBitrate: Double? = 0 {
        didSet {
          ErmisStreamPublisherLib.stream?.videoSettings.bitRate = UInt32(videoBitrate!)
        }
      }
      
      var videoCodec: Bool? = true {
        didSet {
          if videoCodec == true {
            ErmisStreamPublisherLib.stream?.videoSettings.profileLevel = kVTProfileLevel_H264_High_AutoLevel as String
          } else {
            ErmisStreamPublisherLib.stream?.videoSettings.profileLevel = kVTProfileLevel_HEVC_Main_AutoLevel as String
          }
        }
      }
      
      override init() {
        ErmisStreamPublisherView.hkview = MTHKView(frame: view.bounds)
        ErmisStreamPublisherView.hkview!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        ErmisStreamPublisherView.hkview!.backgroundColor = .black
        ErmisStreamPublisherView.hkview!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if !view.subviews.contains(ErmisStreamPublisherView.hkview!) {
          view.addSubview(ErmisStreamPublisherView.hkview!)
        }
        super.init()
      }
}

