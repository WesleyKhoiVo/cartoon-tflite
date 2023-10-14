import UIKit

final class MainView: UIView {
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(.camera, for: .normal)
        button.layer.cornerRadius = Constants.Button.cornerRadius
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = Constants.Button.borderWidth
        button.backgroundColor = .white
        button.tintColor = .black;
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CartoonGan"
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private struct Constants {
        struct Button {
            static let size: CGFloat = 80
            static let cornerRadius: CGFloat = 40
            static let spacing: CGFloat = 32
            static let borderWidth: CGFloat = 3
        }
        struct Title {
            static let topSpacing: CGFloat = 32
            static let sideSpacing: CGFloat = 16
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        addSubviews(titleLabel, cameraButton)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Title.topSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Title.sideSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Title.sideSpacing),
            
            cameraButton.heightAnchor.constraint(equalToConstant: Constants.Button.size),
            cameraButton.widthAnchor.constraint(equalToConstant: Constants.Button.size),
            cameraButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Button.spacing),
            cameraButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Button.spacing),
        ])
    }
}
