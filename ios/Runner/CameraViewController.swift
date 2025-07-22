import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var videoDevice: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        // Run on background thread to avoid UI blocking
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = .photo

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("Camera not found")
                return
            }

            self.videoDevice = device

            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                    self.videoDeviceInput = input
                }
            } catch {
                print("Failed to create input: \(error)")
                return
            }

            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()

            // Back to main thread for UI updates
            DispatchQueue.main.async {
                self.setupPreviewLayer()
                self.setManualFocus(lensPosition: 0.2)
            }
        }
    }

    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill // fill the container while preserving aspect
        previewLayer?.frame = view.bounds
        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)
        }
    }

    func setManualFocus(lensPosition: Float) {
        guard let device = videoDevice else { return }

        do {
            try device.lockForConfiguration()

            print("Supports manual lens control: \(device.isLockingFocusWithCustomLensPositionSupported)")

            let clamped = max(0.0, min(1.0, lensPosition)) // must be 0.0...1.0
            if device.isFocusModeSupported(.locked),
               device.isLockingFocusWithCustomLensPositionSupported {
                device.setFocusModeLocked(lensPosition: clamped) { time in
                    print("Focus locked at position: \(clamped)")
                }
            }

            device.unlockForConfiguration()
        } catch {
            print("Failed to lock focus: \(error)")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds // Make sure it resizes on rotation/layout changes
    }
}

