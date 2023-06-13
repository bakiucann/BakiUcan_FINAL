//
//  DetailRouter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
    static func createModule(with song: Song) -> UIViewController
}

class DetailRouter: DetailRouterProtocol {
    static func createModule(with song: Song) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter()
        let interactor = DetailInteractor()
        let router = DetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.song = song
        interactor.presenter = presenter

        return view
    }
}
