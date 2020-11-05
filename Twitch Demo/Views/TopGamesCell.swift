//
//  TopGamesCell.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import UIKit

class TopGamesCell: UITableViewCell {
    
    var topGame: TopGames? {
        didSet {
            guard let topGame = topGame else { return }
            gameNameLabel.text = topGame.game.name
            viewersLabel.text = "Viewers: \(topGame.viewers)"
            channelsLabel.text = "Channels: \(topGame.channels)"
            downloadImage(fromURL: topGame.game.box.medium)
            
            gameNameLabel.adjustsFontSizeToFitWidth = true
            gameNameLabel.minimumScaleFactor = 0.7
            gameNameLabel.lineBreakMode = .byTruncatingTail
        }
    }
    
    let gameNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.textColor = AppColor.appPrimaryColor
        return lbl
    }()
    
    let viewersLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .left
        lbl.textColor = AppColor.appSecondaryColor
        return lbl
    }()
    
    let channelsLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .left
        lbl.textColor = AppColor.appSecondaryColor
        return lbl
    }()
    
    let gameImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let margins = self.contentView.layoutMarginsGuide
        addsubViews(gameImage, gameNameLabel, viewersLabel, channelsLabel)
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            gameImage.heightAnchor.constraint(equalToConstant: 80),
            gameImage.widthAnchor.constraint(equalToConstant: 80/1.7),
            gameImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 6),
            gameImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),


            gameNameLabel.leadingAnchor.constraint(equalTo: gameImage.trailingAnchor, constant: padding),
            gameNameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: padding),
            gameNameLabel.topAnchor.constraint(equalTo: self.gameImage.topAnchor, constant: 4),

            viewersLabel.leadingAnchor.constraint(equalTo: gameImage.trailingAnchor, constant: padding),
            viewersLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: padding),
            viewersLabel.topAnchor.constraint(equalTo: self.gameNameLabel.bottomAnchor, constant: 4),
            
            channelsLabel.leadingAnchor.constraint(equalTo: gameImage.trailingAnchor, constant: padding),
            channelsLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: padding),
            channelsLabel.topAnchor.constraint(equalTo: self.viewersLabel.bottomAnchor)
        ])
    }
    
    func downloadImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.gameImage.image = image }
        }
    }
}

