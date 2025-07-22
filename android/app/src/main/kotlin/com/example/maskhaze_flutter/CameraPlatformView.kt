package com.example.maskhaze_flutter

import android.content.Context
import android.graphics.Matrix
import android.graphics.RectF
import android.graphics.SurfaceTexture
import android.hardware.camera2.*
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import android.util.Size
import android.view.Surface
import android.view.TextureView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlin.math.abs
import kotlin.math.max

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
                    setManualFocus(context, distance.toFloat())
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        val thread = HandlerThread("CameraThread").also { it.start() }
        backgroundHandler = Handler(thread.looper)

        textureView.surfaceTextureListener = object : TextureView.SurfaceTextureListener {
            override fun onSurfaceTextureAvailable(surface: SurfaceTexture, width: Int, height: Int) {
                configureTransform(width, height)
                openCamera(context)
            }

            override fun onSurfaceTextureSizeChanged(surface: SurfaceTexture, width: Int, height: Int) {}
            override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean = false
            override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {}
        }
    }

    private fun getOptimalPreviewSize(sizes: Array<Size>, width: Int, height: Int): Size {
        val aspectRatio = height.toDouble() / width
        return sizes
            .filter { size -> abs(size.height.toDouble() / size.width - aspectRatio) < 0.1 }
            .minByOrNull { size -> abs(size.height - height) } ?: sizes[0]
    }


    private fun openCamera(context: Context) {
        val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        val cameraId = cameraManager.cameraIdList.first()
        val characteristics = cameraManager.getCameraCharacteristics(cameraId)
        val map = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
        val previewSize = getOptimalPreviewSize(map!!.getOutputSizes(SurfaceTexture::class.java), textureView.width, textureView.height)
        textureView.surfaceTexture?.setDefaultBufferSize(previewSize.width, previewSize.height)

        try {
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

    private fun configureTransform(viewWidth: Int, viewHeight: Int) {
        val rotation = textureView.display.rotation
        val matrix = Matrix()
        val textureRectF = RectF(0f, 0f, viewWidth.toFloat(), viewHeight.toFloat())
        val previewRectF = RectF(0f, 0f, viewHeight.toFloat(), viewWidth.toFloat())

        val centerX = textureRectF.centerX()
        val centerY = textureRectF.centerY()

        if (Surface.ROTATION_90 == rotation || Surface.ROTATION_270 == rotation) {
            previewRectF.offset(centerX - previewRectF.centerX(), centerY - previewRectF.centerY())
            matrix.setRectToRect(textureRectF, previewRectF, Matrix.ScaleToFit.FILL)
            val scale = max(
                viewHeight.toFloat() / viewWidth,
                viewWidth.toFloat() / viewHeight
            )
            matrix.postScale(scale, scale, centerX, centerY)
            matrix.postRotate(90f * (rotation - 2), centerX, centerY)
        }

        textureView.setTransform(matrix)
    }

    private fun createPreviewSession() {
        val texture = textureView.surfaceTexture ?: return
        texture.setDefaultBufferSize(720, 1280)
        val surface = Surface(texture)

        try {
            cameraDevice?.let { camera ->
                previewRequestBuilder = camera.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW).apply {
                    addTarget(surface)

                    // ✅ Disable all auto controls and set manual focus
                    set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO) // or OFF if supported
                    set(CaptureRequest.CONTROL_AF_MODE, CameraMetadata.CONTROL_AF_MODE_OFF)
                    set(CaptureRequest.LENS_FOCUS_DISTANCE, 10.0f) // 1 / distance (meters)

                    // ✅ Optional: Lock AE to reduce focus shifting
                    set(CaptureRequest.CONTROL_AE_MODE, CameraMetadata.CONTROL_AE_MODE_ON)

                    set(CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE, CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE_ON)
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

    private fun setManualFocus(context: Context, distanceMeters: Float) {
        val diopters = 1.0f / distanceMeters
        val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        val cameraId = cameraManager.cameraIdList.first()
        val characteristics = cameraManager.getCameraCharacteristics(cameraId)
        val minFocusDistance = characteristics.get(CameraCharacteristics.LENS_INFO_MINIMUM_FOCUS_DISTANCE) ?: 0.0f
        Log.d("CameraView", "Min focus (diopters): $minFocusDistance")
        val clampedDiopters = diopters.coerceAtMost(minFocusDistance)
        Log.d("CameraView", "Min focus (clamped diopters): $clampedDiopters")

        previewRequestBuilder.apply {
            set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO) // or OFF if supported
            set(CaptureRequest.CONTROL_AF_MODE, CameraMetadata.CONTROL_AF_MODE_OFF)
            set(CaptureRequest.LENS_FOCUS_DISTANCE, clampedDiopters)
            set(CaptureRequest.CONTROL_AE_MODE, CameraMetadata.CONTROL_AE_MODE_ON)
        }

        captureSession?.setRepeatingRequest(previewRequestBuilder.build(), null, null)
    }


    override fun getView(): TextureView = textureView

    override fun dispose() {
        cameraDevice?.close()
        captureSession?.close()
    }
}
