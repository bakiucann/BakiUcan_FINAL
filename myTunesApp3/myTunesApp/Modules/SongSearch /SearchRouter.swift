//
//  SearchRouter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation

protocol SearchRouterProtocol: AnyObject {
    static func createModule() -> SearchViewController
    func pushToSongDetail(with song: Song)
    func goToSongDetail(forSong song: Song)
}

class SearchRouter: SearchRouterProtocol {
    weak var view: SearchViewController?

    static func createModule() -> SearchViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor()
        let router = SearchRouter()
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view

        return view
    }

    func goToSongDetail(forSong song: Song) {
        let songDetailViewController = DetailRouter.createModule(with: song)
        view?.navigationController?.pushViewController(songDetailViewController, animated: true)
    }

    func pushToSongDetail(with song: Song) {
        guard let view = view else {
            return
        }
        let songDetailViewController = DetailRouter.createModule(with: song)
        view.navigationController?.pushViewController(songDetailViewController, animated: true)
    }
}
