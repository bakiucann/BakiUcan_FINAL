//
//  SplashInteractor.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation
import Network

protocol SplashInteractorInputProtocol: AnyObject {
    var presenter: SplashInteractorOutputProtocol? { get set }
    func checkInternetConnection()
}

protocol SplashInteractorOutputProtocol: AnyObject {
    func internetStatus(isConnected: Bool)
}

class SplashInteractor: SplashInteractorInputProtocol {

    weak var presenter: SplashInteractorOutputProtocol?

    private let monitor = NWPathMonitor()

    func checkInternetConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.presenter?.internetStatus(isConnected: true)
            } else {
                self.presenter?.internetStatus(isConnected: false)
            }
        }

        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
    }
}
