//
//  Camera.swift
//  Inbody_Homework
//
//  Created by 김승찬 on 2022/05/15.
//


import UIKit
import AVFoundation

import RxCocoa
import RxSwift

enum CameraType {
    case front
    case back
}

class Camera: NSObject {
    
    // MARK: - Properties
    
    static let shared = Camera()
    
    private var cameraType: CameraType
    private var gridMode: Bool
    
    var session: AVCaptureSession!
    var backInput: AVCaptureDeviceInput!
    var frontInput: AVCaptureDeviceInput!
    var output: AVCapturePhotoOutput!
    var preview: AVCaptureVideoPreviewLayer!
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    
    // MARK: - Initalizer
    
    init(cameraMode: CameraType = .back) {
        self.cameraType = cameraMode
        self.gridMode = false
    }
    
    // MARK: - Methods
    
    func setUp() {
        session = AVCaptureSession()
        session.beginConfiguration()
        if session.canSetSessionPreset(.photo) {
            session.sessionPreset = .photo
        }
        
        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back) {
            backCamera = device
        } else {
            fatalError("cannot use the back camera")
        }
        
        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front) {
            frontCamera = device
        } else {
            fatalError("cannot use the front camera")
        }
        
        guard let backCameraDeviceInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("cannot set the input with the back camera")
        }
        
        backInput = backCameraDeviceInput
        
        if !session.canAddInput(backInput) {
            return
        }
        
        guard let frontCameraDeviceInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("cannot set the input with the front camera")
        }
        
        frontInput = frontCameraDeviceInput
        
        if !session.canAddInput(frontInput) {
            return
        }
        
        session.addInput(backInput)
    }
    
    
    func cameraDataOutput() {
        output = AVCapturePhotoOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        output.connections.first?.videoOrientation = .portrait
        session.commitConfiguration()
        session.startRunning()
    }
    
    func switchCameraInput() {
        switch cameraType {
        case .front:
            session.removeInput(frontInput)
            session.addInput(backInput)
            cameraType = .back
        case .back:
            session.removeInput(backInput)
            session.addInput(frontInput)
            cameraType = .front
        }

        output.connections.first?.isVideoMirrored = (cameraType == .front) ? true : false
    }
}
