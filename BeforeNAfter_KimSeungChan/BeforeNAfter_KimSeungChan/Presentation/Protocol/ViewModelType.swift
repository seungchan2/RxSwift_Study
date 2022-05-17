//
//  ViewModelType.swift
//  Inbody_Homework
//
//  Created by 김승찬 on 2022/05/13.
//

import Foundation

import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }

    func transform(input: Input) -> Output
}

