//
//  DetailRouter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation

protocol DetailRouterProtocol: AnyObject {
    static func createModule(with song: Song) -> DetailViewController
}

class DetailRouter: DetailRouterProtocol {
    // MARK: - Static Method
    static func createModule(with song: Song) -> DetailViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter()
        let interactor = DetailInteractor()
        let router = DetailRouter()

        // Connect modules
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.song = song
        interactor.presenter = presenter

        return view
    }
}
