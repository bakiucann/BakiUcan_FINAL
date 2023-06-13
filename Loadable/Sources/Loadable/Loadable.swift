import UIKit

public protocol Loadable {
    var spinner: UIActivityIndicatorView? { get set }
    func showLoading()
    func hideLoading()
}

extension UIViewController: Loadable {
    public var spinner: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.spinner) as? UIActivityIndicatorView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.spinner, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }


  public func showLoading() {
        DispatchQueue.main.async {
          if #available(iOS 13.0, *) {
            self.spinner = UIActivityIndicatorView(style: .large)
          } else {
          }
            self.spinner?.center = self.view.center
            self.spinner?.startAnimating()
            if let spinner = self.spinner {
                self.view.addSubview(spinner)
            }
        }
    }

    public func hideLoading() {
        DispatchQueue.main.async {
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }

    private struct AssociatedKeys {
        static var spinner = "spinner"
    }
}
