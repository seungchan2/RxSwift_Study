//
//  GithubTableViewCell.swift
//  RxSwift_Github
//
//  Created by 김승찬 on 2022/05/06.
//

import UIKit

import SnapKit
import Then

final class GithubTableViewCell: UITableViewCell {
    var github: Github?
    
    lazy var nameLabel = UILabel().then {
        $0.text = github?.name
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.text = github?.description
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 2
    }
    
    lazy var starImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    lazy var starLabel = UILabel().then {
        $0.text = "\(github?.stargazersCount)"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }
    
    lazy var languageLabel = UILabel().then {
        $0.text = github?.language
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [nameLabel, descriptionLabel, starImageView, starLabel, languageLabel
        ].forEach {
            contentView.addSubview($0)
        }
  
        nameLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        starImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalTo(descriptionLabel)
            $0.width.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        starLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starImageView.snp.trailing).offset(5)
        }
        
        languageLabel.snp.makeConstraints {
            $0.centerY.equalTo(starLabel)
            $0.leading.equalTo(starLabel.snp.trailing).offset(12)
        }
    }
}
