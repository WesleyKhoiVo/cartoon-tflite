import UIKit

final class CartoonViewController: UIViewController {

    private let cartoonImage: UIImage

    private lazy var shareViewController: UIViewController = {
        let shareViewController = UIActivityViewController(activityItems: [cartoonImage], applicationActivities: nil)

        shareViewController.popoverPresentationController?.sourceView = view
        return shareViewController
    }()

    private lazy var cartoonView = CartoonView()
    private var backButton: UIButton { cartoonView.backButton }
    private var shareButton: UIButton { cartoonView.shareButton }

    init(_ cartoonImage: UIImage) {
        self.cartoonImage = cartoonImage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = cartoonView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cartoonView.imageView.image = cartoonImage

        backButton.addTarget(self, action: #selector(onBackButton), for: .touchUpInside)

        shareButton.addTarget(self, action: #selector(onShareButton), for: .touchUpInside)
    }

    @objc func onBackButton() {
        dismiss(animated: true)
    }

    @objc func onShareButton() {
        self.present(shareViewController, animated: true)
    }

}
