//
//  InbodyButton.swift
//  Inbody_Homework
//
//  Created by 김승찬 on 2022/05/13.
//

import UIKit

import SnapKit

enum ButtonMode: Int, CaseIterable {
    case add
    case camera
    case album
    case inactive
}

final class BeforeNAfterButton: UIButton {
    
    private var mode: ButtonMode
    
    init(frame: CGRect, mode: ButtonMode, fontSize: CGFloat) {
        self.mode = mode
        super.init(frame: frame)
        setUI(fontSize: Int(fontSize))
        setupMode(mode: mode)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI(fontSize: Int) {
        titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .bold)
            makeRounded(radius: 10)
    }
    
    private func setupMode(mode: ButtonMode) {
        self.mode = mode
        switch self.mode {
        case .add:
            backgroundColor = .green
            setTitle("+ 추가", for: .normal)
        case .camera:
            backgroundColor = .green
            setTitle("사진 촬영", for: .normal)
            tintColor = .black
        case .album:
            backgroundColor = .green
            setTitle("앨범", for: .normal)
            tintColor = .black
        case .inactive:
            backgroundColor = .darkGray
            setTitle("저장", for: .normal)
            tintColor = .black
        }
    }
}
