//
//  BaseViewController.swift
//  BeforeNAfter_KimSeungChan
//
//  Created by 김승찬 on 2022/05/16.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        hierarchy()
        layout()
    }
    
    public func style() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    public func hierarchy() {}
    public func layout() {}
}
