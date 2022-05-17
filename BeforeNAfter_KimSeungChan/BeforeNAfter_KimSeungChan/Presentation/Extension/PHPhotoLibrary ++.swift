//
//  PHPhotoLibrary ++.swift
//  BeforeNAfter_KimSeungChan
//
//  Created by 김승찬 on 2022/05/16.
//

import Foundation

import RxCocoa
import RxSwift
import PhotosUI

extension Reactive where Base: PHPhotoLibrary {
    static func requestAuthorization() -> Single<PHAuthorizationStatus> {
        return .create { observer in
            let status = Base.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    DispatchQueue.main.async {
                        observer(.success(status))
                    }
                }
            default:
                observer(.success(status))
            }
            return Disposables.create()
        }
    }
}
