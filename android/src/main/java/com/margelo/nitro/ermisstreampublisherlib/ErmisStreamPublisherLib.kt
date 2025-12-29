package com.margelo.nitro.ermisstreampublisherlib

import android.util.Log
import com.facebook.proguard.annotations.DoNotStrip

@DoNotStrip
class ErmisStreamPublisherLib : HybridErmisStreamPublisherLibSpec() {

  private val TAG = "ErmisLib"

  override fun startStream() {
    val camera = ErmisStreamPublisherView.rtmpCamera2
    if (camera == null) {
      Log.e(TAG, "Camera chưa được khởi tạo từ View")
      return
    }

    try {
      if (!camera.isStreaming) {
        // Lấy các giá trị đã được React Native set thông qua View
        val fps = ErmisStreamPublisherView.currentFrameRate
        val videoBitrate = ErmisStreamPublisherView.currentVideoBitrate
        val audioBitrate = ErmisStreamPublisherView.currentAudioBitrate
        val url = ErmisStreamPublisherView.currentRtmpUrl
        val key = ErmisStreamPublisherView.currentStreamKey

        // Chuẩn bị Video/Audio với thông số động
        // Ở đây tạm để mặc định 1920x1080 (16:9), bạn có thể truyền thêm width/height từ RN nếu cần
        val videoReady = camera.prepareVideo(1920, 1080, fps, videoBitrate, 2, 90)
        val audioReady = camera.prepareAudio(audioBitrate, 48000, true)

        if (videoReady && audioReady) {
          val fullUrl = if (key.isNotEmpty()) "$url/$key" else url
          camera.startStream(fullUrl)
          Log.d(TAG, "Đã bắt đầu stream: $fullUrl (Bitrate: $videoBitrate bps, FPS: $fps)")
        } else {
          Log.e(TAG, "Không thể prepare Video ($videoReady) hoặc Audio ($audioReady).")
        }
      } else {
        Log.w(TAG, "Stream đang chạy rồi")
      }
    } catch (e: Exception) {
      Log.e(TAG, "Lỗi khi startStream: ${e.message}")
    }
  }

  override fun stopStream() {
    try {
      ErmisStreamPublisherView.rtmpCamera2?.let {
        if (it.isStreaming) it.stopStream()
      }
    } catch (e: Exception) {
      Log.e(TAG, "Lỗi khi stopStream: ${e.message}")
    }
  }

  override fun flipCamera(position: Boolean) {
    try {
      ErmisStreamPublisherView.rtmpCamera2?.switchCamera()
    } catch (e: Exception) {
      Log.e(TAG, "Lỗi khi flipCamera: ${e.message}")
    }
  }
}
