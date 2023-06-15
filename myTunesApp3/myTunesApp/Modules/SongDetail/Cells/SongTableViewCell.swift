//
//  SongTableViewCell.swift
//  myTunesApp3
//
//  Created by Baki Uçan on 11.06.2023.
//

import UIKit

protocol SongTableViewCellDelegate: AnyObject {
    func didTapPlayButton(on cell: SongTableViewCell)
    func didTapPauseButton(on cell: SongTableViewCell)
}

class SongTableViewCell: UITableViewCell {

    static let identifier = "SongTableViewCell"

    weak var delegate: SongTableViewCellDelegate?

    var playButtonAction: (() -> Void)?
    var pauseButtonAction: (() -> Void)?
    var isPlaying: Bool = false {
        didSet {
            let buttonImage = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.circle.fill")
            playButton.setImage(buttonImage, for: .normal)
        }
    }

    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemPink
        button.accessibilityIdentifier = "detailPlayButton"
        return button
    }()

  private let trackLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
      label.lineBreakMode = .byTruncatingTail
      label.numberOfLines = 1
      return label
  }()


    private let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

  private let priceButton: UIButton = {
      let button = UIButton(type: .system)
      button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = UIFont.systemFont(ofSize: 15.5)
      button.setTitleColor(.gray, for: .normal)
    button.layer.borderWidth = 0.5
      button.layer.borderColor = UIColor.systemPink.cgColor
      button.layer.cornerRadius = 5
      button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 7, bottom: 3, right: 7)
      return button
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
      priceButton.addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)

      contentView.addSubview(trackLabel)
      contentView.addSubview(durationLabel)
      contentView.addSubview(priceButton)
      contentView.addSubview(playButton)

      NSLayoutConstraint.activate([
          trackLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
          trackLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
          trackLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
          trackLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -165),

          durationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
          durationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
          durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -118),

          priceButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
          priceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
          priceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

          playButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
          playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
          playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -65),
          playButton.widthAnchor.constraint(equalToConstant: 30)
      ])

  }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func playButtonTapped() {
        isPlaying.toggle()
        if isPlaying {
            delegate?.didTapPlayButton(on: self)
        } else {
            delegate?.didTapPauseButton(on: self)
        }
    }

    @objc private func priceButtonTapped() {
    }

  func configure(with attributedString: NSAttributedString, duration: String, price: Double) {
      self.trackLabel.attributedText = attributedString
      durationLabel.text = duration
      let formattedPrice = String(format: "%.2f", price)
      priceButton.setTitle("$\(formattedPrice)", for: .normal)
  }
}
