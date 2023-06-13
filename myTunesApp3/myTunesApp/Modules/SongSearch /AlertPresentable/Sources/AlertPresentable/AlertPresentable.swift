import UIKit

public protocol AlertPresentable {
    func showError(withMessage message: String)
}

extension UIViewController: AlertPresentable {
    public func showError(withMessage message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
