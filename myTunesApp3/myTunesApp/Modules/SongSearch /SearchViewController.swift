//
//  SearchViewController.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit
import AlertPresentable
import Loadable

protocol SearchViewProtocol: AnyObject, AlertPresentable, Loadable {
    var presenter: SearchPresenterProtocol? { get set }
    func setupSearchController()
    func setupTableView()
    func showSongs(with songs: [Song])
    func showLoading()
    func hideLoading()
    func showError(withMessage message: String)
    func reloadData()
    func updateButtonImage(at indexPath: IndexPath, to imageName: String)

}

class SearchViewController: UIViewController, SearchViewProtocol {
    var presenter: SearchPresenterProtocol? 
    let searchController = UISearchController(searchResultsController: nil)

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tableView.accessibilityIdentifier = "searchTableView"
        return tableView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "music.quarternote.3"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemPink
      imageView.accessibilityIdentifier = "logoImageView"
        return imageView
    }()

    private lazy var relatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discover Songs"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 24)
        label.accessibilityIdentifier = "relatedLabel"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter?.viewDidLoad()
        self.title = "iTunes Search"
        setupSearchController()
        setupTableView()
        setupLogoImageView()
        setupRelatedLabel()
    }

    func updateButtonImage(at indexPath: IndexPath, to imageName: String) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchCell else {
            return
        }
        let image = UIImage(systemName: imageName)
        cell.playButton.setImage(image, for: .normal)
    }

    func showSongs(with songs: [Song]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = songs.isEmpty
            self.logoImageView.isHidden = !songs.isEmpty
            self.relatedLabel.isHidden = !songs.isEmpty
        }
    }

    func setupSearchController() {
        DispatchQueue.main.async {
            self.navigationItem.searchController = self.searchController
            self.searchController.obscuresBackgroundDuringPresentation = false
            self.searchController.searchBar.delegate = self
            self.searchController.searchBar.accessibilityIdentifier = "searchBar"
        }
    }

    func setupTableView() {
        DispatchQueue.main.async {
            self.view.addSubview(self.tableView)
            NSLayoutConstraint.activate([
                self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    }

  func setupLogoImageView() {
      DispatchQueue.main.async {
          self.view.addSubview(self.logoImageView)
          NSLayoutConstraint.activate([
              self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
              self.logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
              self.logoImageView.widthAnchor.constraint(equalToConstant: 100),
              self.logoImageView.heightAnchor.constraint(equalToConstant: 100)
          ])
      }
  }

  func setupRelatedLabel() {
      DispatchQueue.main.async {
          self.view.addSubview(self.relatedLabel)
          NSLayoutConstraint.activate([
              self.relatedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
              self.relatedLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20)
          ])
      }
  }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfSongs() ?? 0
    }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
      guard let presenter = presenter else {
          return cell
      }
      if let song = presenter.song(for: indexPath) {
        let isPlaying = presenter.isPlaying(for: indexPath)
          cell.configure(with: song, presenter: presenter, isPlaying: isPlaying)
      }
      cell.delegate = self
      return cell
  }

}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.songSelected(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        presenter?.searchSong(with: searchTerm)
        searchController.dismiss(animated: true)
    }
}

extension SearchViewController: SearchCellDelegate {
    func didTapPlayButton(in cell: SearchCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let song = presenter?.song(for: indexPath) {
            presenter?.playButtonTapped(for: song, at: indexPath)
        }
    }
}
