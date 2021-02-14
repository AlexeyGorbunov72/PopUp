//
//  ViewController.swift
//  PopUp
//
//  Created by Alexey on 14.02.2021.
//

import UIKit

class ViewController: UIViewController {
    lazy var popup = PopUpView(delegate: self, text: "хуй блять")
    override func viewDidLoad() {
        super.viewDidLoad()
        print(popup.labelText.text)
    }


}

