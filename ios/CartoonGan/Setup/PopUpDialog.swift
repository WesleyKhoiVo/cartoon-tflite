import PopupDialog

extension PopupDialog {

    private struct Constants {
        static let borderWidth: CGFloat = 3
        static let cornerRadius: Float = 32
    }

    static func setup() {
        PopupDialogContainerView.appearance().cornerRadius = Constants.cornerRadius
        PopupDialogDefaultView.appearance().backgroundColor = .darkGray
        PopupDialogDefaultView.appearance().titleColor = .white
        PopupDialogDefaultView.appearance().messageFont = Font.small
        PopupDialogDefaultView.appearance().messageColor = .white
        DefaultButton.appearance().titleFont = Font.small
        DefaultButton.appearance().buttonColor = .darkGray
        DefaultButton.appearance().titleColor = .white
    }
}
