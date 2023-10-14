import UIKit
import SwiftSpinner

final class ViewController: UIViewController {

    private lazy var cartoonGanModel: CartoonGanModel = {
        let model = CartoonGanModel()
        model.delegate = self
        return model
    }()
    
    private lazy var imagePickerController: ImagePickerController = {
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()

    private var enabled: Bool = false {
        didSet {
            cameraButton.isEnabled = enabled
        }
    }

    private lazy var spinner = UIActivityIndicatorView(style: .large)
    private lazy var mainView = MainView()
    private var cameraButton: UIButton { mainView.cameraButton }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()

        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SwiftSpinner.show("Initializing model...")
        cartoonGanModel.start()
        enabled = false
    }

    @objc private func cameraButtonTapped() {
        imagePickerController.cameraAccessRequest()
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerController.present(parent: self, sourceType: sourceType)
    }

    private func setupSpinner() {
        SwiftSpinner.useContainerView(view)
    }
}

extension ViewController: ImagePickerControllerDelegate {
    func imagePicker(_ imagePicker: ImagePickerController, canUseCamera allowed: Bool) {
        guard allowed
        else {
            log.error("Camera access request failed!")
            return
        }

        presentImagePicker(sourceType: .camera)
    }
    
    func imagePicker(_ imagePicker: ImagePickerController, didSelect image: UIImage) {
        imagePicker.dismiss {
            SwiftSpinner.show("Processing your image...")
            self.cartoonGanModel.process(image)
        }
    }
    
    func imagePicker(_ imagePicker: ImagePickerController, didCancel cancel: Bool) {
        if cancel { imagePicker.dismiss() }
    }

    func imagePicker(_ imagePicker: ImagePickerController, didFail failed: Bool) {
        if failed {
            imagePicker.dismiss()
        }
    }
}

extension ViewController: CartoonGanModelDelegate {
    func model(_ model: CartoonGanModel, didFinishProcessing image: UIImage) {
        DispatchQueue.main.async {
            SwiftSpinner.hide()

            let cartoonViewController = CartoonViewController(image)
            self.present(cartoonViewController, animated: true)
        }
    }

    func model(_ model: CartoonGanModel, didFailedProcessing error: CartoonGanModelError) {
        DispatchQueue.main.async {
            SwiftSpinner.hide()
        }
    }

    func model(_ model: CartoonGanModel, didFinishAllocation error: CartoonGanModelError?) {
        DispatchQueue.main.async {
            SwiftSpinner.hide()
            self.enabled = true
            return
        }
    }
}
