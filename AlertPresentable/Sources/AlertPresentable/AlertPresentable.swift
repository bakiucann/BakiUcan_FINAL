import UIKit
import Loadable

public protocol AlertPresentable {
    func showNoResults()
    func showError(withMessage message: String)
}

extension UIViewController: AlertPresentable {
    public func showNoResults() {
        showError(withMessage: "No songs found.")
    }

    public func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.hideLoading()
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
