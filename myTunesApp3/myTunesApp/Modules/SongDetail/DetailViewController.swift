//
//  DetailViewController.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit
import Loadable
import AlertPresentable

protocol DetailViewProtocol: AnyObject, AlertPresentable {
    var presenter: DetailPresenterProtocol? { get set }
    func displaySongDetails(_ song: Song)
    func displayArtwork(_ image: UIImage)
    func displayPlaceholderArtwork()
    func displayCollectionPrice(_ price: Double)
    func displayAlbumSongs(_ songs: [Song])
    func getArtworkImageView() -> UIImageView?
    func showConfirmationAlert(with message: String, confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void)
}

class DetailViewController: UIViewController, DetailViewProtocol {
    var presenter: DetailPresenterProtocol?
    var songsInAlbum: [Song] = []
    var durationFormatter: DurationFormatter = DefaultDurationFormatter()
    var currentlyPlayingSongId: Int?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.accessibilityIdentifier = "detailTableView"
        return tableView
    }()

    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    private let collectionPriceLabel: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.gray, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        showLoading()
        presenter?.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .systemPink
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        favoriteButton.accessibilityIdentifier = "favoriteButton"
        navigationItem.rightBarButtonItem = favoriteButton
        if let song = presenter?.song, song.isFavorite {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
    }

    @objc func favoriteButtonTapped() {
        guard let song = presenter?.song else { return }
        let isFavorite = song.isFavorite

        if isFavorite {
            let confirmAction: () -> Void = { [weak self] in
                self?.presenter?.didTapUnfavoriteButton()
                self?.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }

            let cancelAction: () -> Void = {
                // Do nothing
            }

            let message = "Remove from favorites?"
            showConfirmationAlert(with: message, confirmAction: confirmAction, cancelAction: cancelAction)
        } else {
            presenter?.didTapFavoriteButton()
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
    }

    func displaySongDetails(_ song: Song) {
        self.titleLabel.text = song.trackName
        self.artistLabel.text = song.artistName
        self.genreLabel.text = song.primaryGenreName
    }

    func displayCollectionPrice(_ price: Double) {
        let formattedPrice = String(format: "%.2f", price)
        collectionPriceLabel.setTitle("Album Price: $\(formattedPrice)", for: .normal)
    }

    func displayArtwork(_ image: UIImage) {
        hideLoading()
        self.artworkImageView.image = image
    }

    func getArtworkImageView() -> UIImageView? {
        return artworkImageView
    }

    func showConfirmationAlert(with message: String, confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Confirmation", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default) { _ in confirmAction() }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in cancelAction() }
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }

    func displayPlaceholderArtwork() {
        hideLoading()
        self.artworkImageView.image = UIImage(named: "placeholder")
    }

    func displayAlbumSongs(_ songs: [Song]) {
        self.songsInAlbum = songs.filter { $0.kind == "song" }.sorted { $0.trackId ?? 0 < $1.trackId ?? 0 }
        currentlyPlayingSongId = nil
        self.tableView.reloadData()
    }

  private func setupViews() {
      let stackView = UIStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.axis = .horizontal
      stackView.spacing = 16

      stackView.addArrangedSubview(artworkImageView)

      let labelsStackView = UIStackView()
      labelsStackView.translatesAutoresizingMaskIntoConstraints = false
      labelsStackView.axis = .vertical
      labelsStackView.spacing = 8

      labelsStackView.addArrangedSubview(titleLabel)
      labelsStackView.addArrangedSubview(artistLabel)
      labelsStackView.addArrangedSubview(genreLabel)
      labelsStackView.addArrangedSubview(collectionPriceLabel)

      stackView.addArrangedSubview(labelsStackView)

      view.addSubview(stackView)
      view.addSubview(tableView)

      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)

      let safeArea = view.safeAreaLayoutGuide

      NSLayoutConstraint.activate([
          stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
          stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
          stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),

          artworkImageView.widthAnchor.constraint(equalToConstant: 130),
          artworkImageView.heightAnchor.constraint(equalToConstant: 130),

          labelsStackView.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
          labelsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

          tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
          tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
          tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
          tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
      ])
  }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsInAlbum.count
    }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as! SongTableViewCell
      cell.accessibilityIdentifier = "songCell_\(indexPath.row)"
      let song = songsInAlbum[indexPath.row]
      let trackName = String(format: "%-5d %@", indexPath.row + 1, song.trackName ?? "")

          cell.delegate = self

      let attributedString = presenter?.attributedString(for: trackName) ?? NSAttributedString(string: trackName)

      if let trackTimeMillis = song.trackTimeMillis {
          let duration = durationFormatter.format(milliseconds: trackTimeMillis)
          cell.configure(with: attributedString, duration: duration, price: song.trackPrice ?? 0.0)
      } else {
          cell.configure(with: attributedString, duration: "", price: song.trackPrice ?? 0.0)
      }

      cell.isPlaying = song.trackId == currentlyPlayingSongId

      cell.playButtonAction = { [weak self] in
          self?.currentlyPlayingSongId = song.trackId
          self?.tableView.reloadData()
          self?.presenter?.didTapPlayButton(for: song)
      }

      cell.pauseButtonAction = { [weak self] in
          if self?.currentlyPlayingSongId == song.trackId {
              self?.currentlyPlayingSongId = nil
              self?.tableView.reloadData()
          }
          self?.presenter?.didTapPauseButton(for: song)
      }

      return cell
  }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white

        let leadingSpace: CGFloat = 51
        let labels = ["NAME", "DURATION", "LISTEN", "PRICE"]
        let labelWidths: [CGFloat] = [32, 368, 455, 520]
        let padding: CGFloat = 16

        for (index, labelText) in labels.enumerated() {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 10)
            label.textColor = .lightGray
            label.textAlignment = .center
            label.text = labelText

            headerView.addSubview(label)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: leadingSpace + padding * CGFloat(index)),
                label.widthAnchor.constraint(equalToConstant: labelWidths[index]),
                label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
extension DetailViewController: SongTableViewCellDelegate {
    func didTapPlayButton(on cell: SongTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let song = songsInAlbum[indexPath.row]
        currentlyPlayingSongId = song.trackId
        tableView.reloadData()
        presenter?.didTapPlayButton(for: song)
    }

    func didTapPauseButton(on cell: SongTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let song = songsInAlbum[indexPath.row]
        if currentlyPlayingSongId == song.trackId {
            currentlyPlayingSongId = nil
            tableView.reloadData()
        }
        presenter?.didTapPauseButton(for: song)
    }
  }
