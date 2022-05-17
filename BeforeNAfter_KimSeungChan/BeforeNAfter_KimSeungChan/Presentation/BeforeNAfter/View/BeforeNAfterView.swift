//
//  BeforeNAfterView.swift.swift
//  BeforeNAfter_KimSeungChan
//
//  Created by 김승찬 on 2022/05/13.
//

import UIKit

import SnapKit
import Then
import AVFoundation

final class BeforeNAfterView: UIView, ViewPresentable {
    
    lazy var titleLabel = UILabel().then {
        $0.text = "Before&After"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .black
    }
    
    lazy var beforePhotoImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.dropShadow()
        $0.makeRoundedSpecificCorner([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 10)
    }
    
    lazy var afterPhotoImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.dropShadow()
        $0.makeRoundedSpecificCorner([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 10)
    }
    
    lazy var imageBackgroundView = UIView()
    
    lazy var beforeAddButton = BeforeNAfterButton(frame: CGRect(), mode: .add, fontSize: 18)
    lazy var afterAddButton = BeforeNAfterButton(frame: CGRect(), mode: .add, fontSize: 18)
    
    lazy var beforeCameraButton = BeforeNAfterButton(frame: CGRect(), mode: .camera, fontSize: 18)
    lazy var afterCameraButton = BeforeNAfterButton(frame: CGRect(), mode: .camera, fontSize: 18)
    
    lazy var beforeAlbumButton = BeforeNAfterButton(frame: CGRect(), mode: .album, fontSize: 18)
    lazy var afterAlbumButton = BeforeNAfterButton(frame: CGRect(), mode: .album, fontSize: 18)
    
    lazy var beforeLabelBackgroundView = UIView().then {
        $0.backgroundColor = .green
        $0.makeRounded(radius: 8)
    }
    
    lazy var afterLabelBackgroundView = UIView().then {
        $0.backgroundColor = .green
        $0.makeRounded(radius: 8)
    }
    
    lazy var beforeTextLabel = UILabel().then {
        $0.text = "전"
    }
    
    lazy var afterTextLabel = UILabel().then {
        $0.text = "후"
    }
    
    lazy var beforeStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    
    lazy var afterStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    
    lazy var saveButton = BeforeNAfterButton(frame: CGRect(), mode: .inactive, fontSize: 18)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        beforeLabelBackgroundView.isHidden = true
        afterLabelBackgroundView.isHidden = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        [beforeAddButton, beforeAlbumButton, beforeCameraButton].forEach {
            beforeStackView.addArrangedSubview($0)
        }
        
        [afterAddButton, afterAlbumButton, afterCameraButton].forEach {
            afterStackView.addArrangedSubview($0)
        }
        
        [titleLabel, saveButton, beforeLabelBackgroundView, afterLabelBackgroundView, imageBackgroundView].forEach {
            addSubview($0)
            
            [beforePhotoImageView, afterPhotoImageView, beforeLabelBackgroundView, afterLabelBackgroundView, beforeStackView, afterStackView].forEach {
                imageBackgroundView.addSubview($0)
            }
  
            beforeLabelBackgroundView.addSubview(beforeTextLabel)
            afterLabelBackgroundView.addSubview(afterTextLabel)

        }
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        beforePhotoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.95)
            $0.leading.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 20)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.55)
        }
        
        afterPhotoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.95)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 20)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.55)
        }
        
        beforeAddButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 80)
        }
        
        beforeCameraButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 80)
        }
        
        beforeAlbumButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 80)
        }
        
        beforeStackView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(beforePhotoImageView)
        }
        
        afterAddButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 80)
        }
        
        afterCameraButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 80)
        }
        
        afterAlbumButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 80)
        }
        
        afterStackView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(afterPhotoImageView)
        }
        
        beforeLabelBackgroundView.snp.makeConstraints {
            $0.centerX.equalTo(beforePhotoImageView)
            $0.bottom.equalTo(beforePhotoImageView.snp.bottom)
            $0.width.height.equalTo(50)
        }
        
        afterLabelBackgroundView.snp.makeConstraints {
            $0.centerX.equalTo(afterPhotoImageView)
            $0.bottom.equalTo(afterPhotoImageView.snp.bottom)
            $0.width.height.equalTo(50)
        }
        
        beforeTextLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(beforeLabelBackgroundView)
        }
        
        afterTextLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(afterLabelBackgroundView)
        }
        
        imageBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.95)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.55)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(22)
            $0.height.equalTo(54)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
