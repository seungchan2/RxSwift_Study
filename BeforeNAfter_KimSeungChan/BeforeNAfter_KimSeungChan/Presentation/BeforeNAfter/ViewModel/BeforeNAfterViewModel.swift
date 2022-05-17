//
//  InbodyViewModel.swift
//  Inbody_Homework
//
//  Created by 김승찬 on 2022/05/13.
//

import UIKit

import Photos
import RxSwift
import RxCocoa

final class BeforeNAfterViewModel: ViewModelType {
   
    struct Input {
        let didBeforeAddButtonTapped: Signal<Void>
        let didAfterAddButtonTapped: Signal<Void>
    }
    
    struct Output {
        let isBeforeButtonHidden: Driver<Bool>
        let isAfterButtonHidden: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    private let isBeforeButtonHidden = BehaviorRelay<Bool>(value: false)
    private let isAlbumHidden = BehaviorRelay<Bool>(value: false)
    private let isAfterButtonHidden = BehaviorRelay<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        input.didBeforeAddButtonTapped
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.isBeforeButtonHidden.accept(!self.isBeforeButtonHidden.value)
            })
            .disposed(by: disposeBag)
        
        input.didAfterAddButtonTapped
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.isAfterButtonHidden.accept(!self.isAfterButtonHidden.value)
            })
            .disposed(by: disposeBag)
        
        isBeforeButtonHidden
            .subscribe(onNext: { [weak self] isSelected in
                if isSelected {
                    self?.isAlbumHidden.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        isAfterButtonHidden
            .subscribe(onNext: { [weak self] isSelected in
                if isSelected {
                    self?.isAlbumHidden.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        return Output (
            isBeforeButtonHidden: isBeforeButtonHidden.asDriver(),
            isAfterButtonHidden: isAfterButtonHidden.asDriver()
        )
    }
}
