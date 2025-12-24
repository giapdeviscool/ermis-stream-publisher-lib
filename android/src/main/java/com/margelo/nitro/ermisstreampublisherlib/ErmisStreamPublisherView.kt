package com.margelo.nitro.ermisstreampublisherlib

import android.util.Log
import android.view.SurfaceHolder
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.facebook.proguard.annotations.DoNotStrip
import com.facebook.react.uimanager.ThemedReactContext
import com.pedro.common.ConnectChecker
import com.pedro.library.rtmp.RtmpCamera2
import com.pedro.library.view.OpenGlView
import java.lang.ref.WeakReference

@DoNotStrip
class ErmisStreamPublisherView(context: ThemedReactContext) : HybridErmisStreamPublisherViewSpec(), SurfaceHolder.Callback, ConnectChecker {
    companion object {
        private var cameraRef: WeakReference<RtmpCamera2>? = null

        var rtmpCamera2: RtmpCamera2?
            get() = cameraRef?.get()
            set(value) {
                cameraRef = if (value == null) null else WeakReference(value)
            }

        // Lưu trữ cấu hình tĩnh để Module có thể truy cập
        var currentRtmpUrl: String = ""
        var currentStreamKey: String = ""
        var currentFrameRate: Int = 30
        var currentVideoBitrate: Int = 2500 * 1000 // bps
        var currentAudioBitrate: Int = 160 * 1024 // bps
    }

    private var ermisview: OpenGlView
    override val view: View

    // --- Cập nhật giá trị từ React Native ---
    override var rtmpUrl: String = ""
        set(value) {
            field = value
            currentRtmpUrl = value
        }

    override var streamKey: String = ""
        set(value) {
            field = value
            currentStreamKey = value
        }

    override var frameRate: Double? = 30.0
        set(value) {
            field = value
            currentFrameRate = value?.toInt() ?: 30
        }

    override var audioBitrate: Double? = 128.0
        set(value) {
            field = value
            currentAudioBitrate = (value?.toInt() ?: 128) * 1024
        }

    override var videoBitrate: Double? = 2500.0
        set(value) {
            field = value
            val bps = (value?.toInt() ?: 2500) * 1000
            currentVideoBitrate = bps
            // Nếu đang stream, cập nhật bitrate ngay lập tức (On the fly)
            if (rtmpCamera2?.isStreaming == true) {
                rtmpCamera2?.setVideoBitrateOnFly(bps)
                Log.d("ErmisView", "Updated video bitrate on fly to: $bps bps")
            }
        }

    override var videoCodec: Boolean? = true
        set(value) {
            field = value
        }

    // --- SurfaceHolder.Callback ---
    override fun surfaceCreated(holder: SurfaceHolder) {
        Log.d("ErmisView", "Surface created")
        rtmpCamera2?.startPreview()
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {}

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        Log.d("ErmisView", "Surface destroyed")
        rtmpCamera2?.let {
            if (it.isStreaming) it.stopStream()
            it.stopPreview()
        }
        rtmpCamera2 = null
    }

    // --- ConnectChecker Callbacks ---
    override fun onConnectionStarted(url: String) { Log.d("ErmisView", "Connecting: $url") }
    override fun onConnectionSuccess() { Log.d("ErmisView", "Connected") }
    override fun onConnectionFailed(reason: String) { Log.e("ErmisView", "Failed: $reason") }
    override fun onDisconnect() { Log.d("ErmisView", "Disconnected") }
    override fun onAuthError() { Log.e("ErmisView", "Auth error") }
    override fun onAuthSuccess() { Log.d("ErmisView", "Auth success") }

    init {
        this.view = FrameLayout(context)
        this.ermisview = OpenGlView(context)
        this.ermisview.holder.addCallback(this)

        val layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        view.addView(ermisview, layoutParams)

        rtmpCamera2 = RtmpCamera2(ermisview, this)
    }
}
