//
//  SearchRouter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit

protocol SearchRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func pushToSongDetail(with song: Song, from view: UIViewController)
}

class SearchRouter: SearchRouterProtocol {
    static func createModule() -> UIViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor()
        let router = SearchRouter()
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter

        return view
    }

    func pushToSongDetail(with song: Song, from view: UIViewController) {
        let songDetailViewController = DetailRouter.createModule(with: song)
        view.navigationController?.pushViewController(songDetailViewController, animated: true)
    }
}
