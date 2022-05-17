//
//  InbodyViewController.swift
//  Inbody_Homework
//
//  Created by 김승찬 on 2022/05/13.
//

import UIKit

import Photos
import RxSwift
import RxCocoa

final class BeforeNAfterViewController: BaseViewController {
    
    private lazy var input = BeforeNAfterViewModel.Input (
        didBeforeAddButtonTapped: beforeNAfterView.beforeAddButton.rx.tap.asSignal(),
        didAfterAddButtonTapped: beforeNAfterView.afterAddButton.rx.tap.asSignal()
    )
    
    private lazy var output = viewModel.transform(input: input)
    private var viewModel = BeforeNAfterViewModel()
    
    private var beforeImageHidden = BehaviorSubject<Bool>(value: false)
    private var afterImageHidden = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    private let beforeImagePicker = UIImagePickerController()
    private let afterImagePicker = UIImagePickerController()
    
    private let beforeNAfterView = BeforeNAfterView()
    
    override func loadView() {
        self.view = beforeNAfterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        assignDelegation()
    }
    
    private func bind() {
        output.isBeforeButtonHidden.drive(onNext: {
            self.beforeNAfterView.beforeAddButton.isHidden = $0
            self.beforeNAfterView.beforeAlbumButton.isHidden = !$0
            self.beforeNAfterView.beforeCameraButton.isHidden = !$0
        })
        .disposed(by: disposeBag)
        
        output.isAfterButtonHidden.drive(onNext: {
            self.beforeNAfterView.afterAddButton.isHidden = $0
            self.beforeNAfterView.afterAlbumButton.isHidden = !$0
            self.beforeNAfterView.afterCameraButton.isHidden = !$0
        })
        .disposed(by: disposeBag)
        
        beforeNAfterView.beforeAlbumButton.rx.tap
            .flatMap { PHPhotoLibrary.rx.requestAuthorization() }
            .map { $0 == .authorized }
            .bind { [self] authorized in
                if authorized {
                    beforeImagePicker.sourceType = .photoLibrary
                    self.present(self.beforeImagePicker, animated: true, completion: nil)
                } else {
                    self.beforeButtonisHidden(isHidden: false)
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        beforeNAfterView.beforeCameraButton.rx.tap
            .bind { [self] in
                checkCamera(picker: beforeImagePicker)
            }
            .disposed(by: disposeBag)
        
        beforeNAfterView.afterAlbumButton.rx.tap
            .flatMap { PHPhotoLibrary.rx.requestAuthorization() }
            .map { $0 == .authorized }
            .bind { authorized in
                if authorized {
                    self.afterImagePicker.sourceType = .photoLibrary
                    self.present(self.afterImagePicker, animated: true, completion: nil)
                } else {
                    self.afterButtonisHidden(isHidden: false)
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        beforeNAfterView.afterCameraButton.rx.tap
            .bind { [self] in
                checkCamera(picker: afterImagePicker)
            }
            .disposed(by: disposeBag)
        
        beforeNAfterView.beforePhotoImageView.rx.isEmpty
            .subscribe(onNext: { isEmpty in
            if isEmpty {
                self.beforeImageHidden.onNext(false)
            } else {
                self.beforeImageHidden.onNext(true)
            }
        })
        .disposed(by: disposeBag)
        
        beforeNAfterView.afterPhotoImageView.rx.isEmpty
            .subscribe(onNext: { isEmpty in
            if isEmpty {
                self.afterImageHidden.onNext(false)
            } else {
                self.afterImageHidden.onNext(true)
            }
        })
        .disposed(by: disposeBag)
        
        Observable.combineLatest(beforeImageHidden, afterImageHidden, resultSelector: {$0 && $1})
            .subscribe(onNext: { isEnabled in
                self.beforeNAfterView.saveButton.isEnabled = isEnabled
                isEnabled ? self.beforeNAfterView.saveButton.backgroundColor = .yellow : print("isEnabled == False")
            })
            .disposed(by: disposeBag)
        
        beforeNAfterView.saveButton.rx.tap
            .bind { [self] in
                transformUIView()
                reset()
            }
            .disposed(by: disposeBag)
    }
}

extension BeforeNAfterViewController {
    private func assignDelegation() {
        beforeImagePicker.delegate = self
        afterImagePicker.delegate = self
    }
    
    private func reset() {
        beforeNAfterView.beforePhotoImageView.image = nil
        beforeNAfterView.beforeAddButton.isHidden = false
        beforeNAfterView.beforeLabelBackgroundView.isHidden = true
        
        beforeNAfterView.afterPhotoImageView.image = nil
        beforeNAfterView.afterAddButton.isHidden = false
        beforeNAfterView.afterLabelBackgroundView.isHidden = true
       
        beforeNAfterView.saveButton.isEnabled = false
        beforeNAfterView.saveButton.backgroundColor = .gray
    }
    
    private func transformUIView() {
        guard let image = beforeNAfterView.imageBackgroundView.transformToImage() else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
    
    private func beforeButtonisHidden(isHidden: Bool) {
        beforeNAfterView.beforeCameraButton.isHidden = isHidden
        beforeNAfterView.beforeAlbumButton.isHidden = isHidden
        beforeNAfterView.beforeLabelBackgroundView.isHidden = !isHidden
    }
    
    private func afterButtonisHidden(isHidden: Bool) {
        beforeNAfterView.afterCameraButton.isHidden = isHidden
        beforeNAfterView.afterAlbumButton.isHidden = isHidden
        beforeNAfterView.afterLabelBackgroundView.isHidden = !isHidden
    }
}

extension BeforeNAfterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if picker == beforeImagePicker {
                beforeNAfterView.beforePhotoImageView.image = image
                self.beforeButtonisHidden(isHidden: true)
            } else if picker == afterImagePicker {
                beforeNAfterView.afterPhotoImageView.image = image;   afterButtonisHidden(isHidden: true)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        if picker == beforeImagePicker {
            beforeButtonisHidden(isHidden: false)
        } else if picker == afterImagePicker {
            afterButtonisHidden(isHidden: false)
        }
        
        picker.dismiss(animated: true, completion: nil) }
}

extension BeforeNAfterViewController {
    func checkCamera(picker: UIImagePickerController) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            if picker == self.beforeImagePicker {
                beforeButtonisHidden(isHidden: true)
                self.beforeImagePicker.sourceType = .camera
                self.present(self.beforeImagePicker, animated: true, completion: nil)
            } else if picker == self.afterImagePicker {
                afterButtonisHidden(isHidden: true)
                self.afterImagePicker.sourceType = .camera
                self.present(self.afterImagePicker, animated: true, completion: nil)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                state in
                if state == .authorized {
                    DispatchQueue.main.async {
                        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                            
                            if picker == self.beforeImagePicker {
                                self.beforeImagePicker.sourceType = .photoLibrary
                                self.present(self.beforeImagePicker, animated: true, completion: nil)
                            } else if picker == self.afterImagePicker {
                                self.afterImagePicker.sourceType = .photoLibrary
                                self.present(self.afterImagePicker, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    self.dismiss(animated: true)
                }
            })
        @unknown default:
            break
        }
    }
}

