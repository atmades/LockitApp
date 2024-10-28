import JGProgressHUD

extension JGProgressHUD {
    static func light() -> JGProgressHUD {
        return JGProgressHUD(style: .light)
    }

    func show(in controller: UIViewController) {
        guard let navigationController = controller.navigationController else {
            show(in: controller.view)
            return
        }
        show(in: navigationController.view)
    }
}
