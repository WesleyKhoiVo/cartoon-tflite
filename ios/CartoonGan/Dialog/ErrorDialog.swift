import PopupDialog

final class ErrorDialog {

    private var dialog: PopupDialog

    init(message: String) {
        dialog = PopupDialog(
            title: "☹️",
            message: message,
            buttonAlignment: .horizontal,
            transitionStyle: .bounceDown
        )

        dialog.addButton(
            DefaultButton(
                title: "Oh... OK",
                dismissOnTap: true,
                action: nil
            )
        )
    }

    func present(
        _ parent: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        parent.present(
            dialog,
            animated: true,
            completion: completion
        )
    }
}
