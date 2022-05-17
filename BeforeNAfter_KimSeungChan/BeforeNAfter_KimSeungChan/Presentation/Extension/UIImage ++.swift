//
//  UIImage ++.swift
//  BeforeNAfter_KimSeungChan
//
//  Created by 김승찬 on 2022/05/16.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIImageView {
    var isEmpty: Observable<Bool> {
        return observe(UIImage.self, "image").map{ $0 == nil }
    }
}
