class CameraPlatformView: NSObject, FlutterPlatformView {
    private let cameraViewController: CameraViewController

    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger) {
        self.cameraViewController = CameraViewController()
        super.init()

        // Optional method channel setup here for communication
        let channel = FlutterMethodChannel(name: "native_camera", binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "setManualFocus":
                if let args = call.arguments as? [String: Any],
                   let distance = args["distance"] as? Double {
                    self?.cameraViewController.setManualFocus(lensPosition: Float(distance)) // meters → cm
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func view() -> UIView {
        return cameraViewController.view
    }
}
