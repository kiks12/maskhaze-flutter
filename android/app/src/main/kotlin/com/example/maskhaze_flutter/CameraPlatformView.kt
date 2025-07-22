package com.example.maskhaze_flutter

import android.content.Context
import android.graphics.SurfaceTexture
import android.hardware.camera2.*
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import android.view.Surface
import android.view.TextureView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class CameraPlatformView(context: Context, id: Int, messenger: BinaryMessenger) : PlatformView {
    private val methodChannel = MethodChannel(messenger, "native_camera")
    private val textureView = TextureView(context).apply {
        layoutParams = android.view.ViewGroup.LayoutParams(
            android.view.ViewGroup.LayoutParams.MATCH_PARENT,
            android.view.ViewGroup.LayoutParams.MATCH_PARENT,
        )
    }
    private var cameraDevice: CameraDevice? = null
    private var captureSession: CameraCaptureSession? = null
    private lateinit var previewRequestBuilder: CaptureRequest.Builder
    private val backgroundHandler: Handler

    init {
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setManualFocus" -> {
                    val distance = (call.argument<Double>("distance") ?: 1.0)
                    setManualFocus(distance.toFloat())
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        val thread = HandlerThread("CameraThread").also { it.start() }
        backgroundHandler = Handler(thread.looper)

        textureView.surfaceTextureListener = object : TextureView.SurfaceTextureListener {
            override fun onSurfaceTextureAvailable(surface: SurfaceTexture, width: Int, height: Int) {
                openCamera(context)
            }

            override fun onSurfaceTextureSizeChanged(surface: SurfaceTexture, width: Int, height: Int) {}
            override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean = false
            override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {}
        }
    }

    private fun openCamera(context: Context) {
        val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            val cameraId = cameraManager.cameraIdList.first()
            cameraManager.openCamera(cameraId, object : CameraDevice.StateCallback() {
                override fun onOpened(camera: CameraDevice) {
                    cameraDevice = camera
                    createPreviewSession()
                }

                override fun onDisconnected(camera: CameraDevice) {
                    camera.close()
                }

                override fun onError(camera: CameraDevice, error: Int) {
                    camera.close()
                }
            }, backgroundHandler)
        } catch (e: SecurityException) {
            Log.e("CameraPlatformView", "Camera permission not granted", e)
        } catch (e: Exception) {
            Log.e("CameraPlatformView", "Error opening camera", e)
        }
    }

    private fun createPreviewSession() {
        val texture = textureView.surfaceTexture ?: return
        texture.setDefaultBufferSize(1280, 720)
        val surface = Surface(texture)

        try {
            cameraDevice?.let { camera ->
                previewRequestBuilder = camera.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW).apply {
                    addTarget(surface)

                    // ✅ Disable all auto controls and set manual focus
                    set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO) // or OFF if supported
                    set(CaptureRequest.CONTROL_AF_MODE, CameraMetadata.CONTROL_AF_MODE_OFF)
                    set(CaptureRequest.LENS_FOCUS_DISTANCE, 0.1f) // 1 / distance (meters)

                    // ✅ Optional: Lock AE to reduce focus shifting
                    set(CaptureRequest.CONTROL_AE_MODE, CameraMetadata.CONTROL_AE_MODE_ON)
                }

                camera.createCaptureSession(listOf(surface), object : CameraCaptureSession.StateCallback() {
                    override fun onConfigured(session: CameraCaptureSession) {
                        captureSession = session
                        session.setRepeatingRequest(previewRequestBuilder.build(), null, backgroundHandler)
                    }

                    override fun onConfigureFailed(session: CameraCaptureSession) {
                        Log.e("CameraPlatformView", "Capture session configuration failed")
                    }
                }, backgroundHandler)
            }
        } catch (e: CameraAccessException) {
            Log.e("CameraPlatformView", "Failed to start preview session", e)
        }
    }

    private fun setManualFocus(distanceMeters: Float) {
        val diopters = 1.0f / distanceMeters

        previewRequestBuilder.apply {
            set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO) // or OFF if supported
            set(CaptureRequest.CONTROL_AF_MODE, CameraMetadata.CONTROL_AF_MODE_OFF)
            set(CaptureRequest.LENS_FOCUS_DISTANCE, diopters)
            set(CaptureRequest.CONTROL_AE_MODE, CameraMetadata.CONTROL_AE_MODE_ON)
        }

        captureSession?.setRepeatingRequest(previewRequestBuilder!!.build(), null, null)
    }


    override fun getView(): TextureView = textureView

    override fun dispose() {
        cameraDevice?.close()
        captureSession?.close()
    }
}
