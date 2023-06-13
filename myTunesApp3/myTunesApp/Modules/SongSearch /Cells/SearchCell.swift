//
//  SearchCell.swift
//  myTunesApp2
//
//  Created by Baki Uçan on 7.06.2023.
//

import UIKit

protocol SearchCellDelegate: AnyObject {
    func didTapPlayButton(in cell: SearchCell)
}

class SearchCell: UITableViewCell {
    static let identifier = "SearchCell"
    weak var delegate: SearchCellDelegate?
    var playButtonTapped: (() -> Void)?

    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

  private let playButton: UIButton = {
      let button = UIButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
      button.tintColor = .systemPink
      button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      return button
  }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)

        contentView.addSubview(artworkImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(playButton)

        NSLayoutConstraint.activate([
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            artworkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkImageView.heightAnchor.constraint(equalToConstant: 80),
            artworkImageView.widthAnchor.constraint(equalTo: artworkImageView.heightAnchor),

            trackNameLabel.topAnchor.constraint(equalTo: artworkImageView.topAnchor),
            trackNameLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 12),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 4),
            artistNameLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: trackNameLabel.trailingAnchor),

            albumNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 4),
            albumNameLabel.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor),
            albumNameLabel.trailingAnchor.constraint(equalTo: artistNameLabel.trailingAnchor),

            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  func configure(with song: Song, isPlaying: Bool) {
      self.trackNameLabel.text = song.trackName
      self.artistNameLabel.text = song.artistName
      let imageName = isPlaying ? "pause.fill" : "play.circle.fill"
      let image = UIImage(systemName: imageName)
      playButton.setImage(image, for: .normal)

      if let albumName = song.collectionName {
          self.albumNameLabel.text = "Album: \(albumName)"
      } else {
          self.albumNameLabel.text = "Album: Unknown"
      }

     if let artworkUrlString = song.artworkUrl100, let artworkUrl = URL(string: artworkUrlString) {
          URLSession.shared.dataTask(with: artworkUrl) { (data, response, error) in
              if let data = data {
                  DispatchQueue.main.async {
                      self.artworkImageView.image = UIImage(data: data)
                  }
              }
          }.resume()
      }
  }


  @objc private func didTapPlayButton() {
      delegate?.didTapPlayButton(in: self)
  }


}