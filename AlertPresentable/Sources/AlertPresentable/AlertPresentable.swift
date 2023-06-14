import UIKit
import Loadable //İlk açılışta (bazen) bunu ve dolayısıyla alttaki hideLoading fonksiyonunu algılamıyor. Bu importu ve hideLoading'i kaldırıp build edilip sonradan eklendiğinde sorunsuz çalışıyor ve tekrar bu problem olmuyor.

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
