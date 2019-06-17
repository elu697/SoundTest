//
//  ViewController.swift
//  SoundTest
//
//  Created by El You on 2019/06/15.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var toneBtn: UIButton!
    @IBOutlet weak var idTxf: UITextField!
    @IBOutlet weak var idStepper: UIStepper!

    var toneFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        idStepper.minimumValue = 1000
        idStepper.maximumValue = 10000
        idLabel.text = "1000"
        idTxf.text = "1000"

        idTxf.keyboardType = .numberPad
        // Do any additional setup after loading the view.
    }
    @IBAction func idTxf(_ sender: UITextField) {
        idLabel.text = sender.text
        idStepper.value = Double(sender.text ?? "") ?? 1000
    }

    @IBAction func idStepper(_ sender: UIStepper) {
        idLabel.text = String(Int(sender.value))
        idTxf.text = String(Int(sender.value))
    }

    @IBAction func downToneBtn(_ sender: UIButton) {
        toneFlag = true
        tone()
    }
    @IBAction func upToneBtn(_ sender: UIButton) {
        toneFlag = false
    }

    func tone() {
        var soundId: UInt32 = UInt32(idLabel.text ?? "") ?? 1000
        do {
            DispatchQueue.global().async {
                while self.toneFlag {
                    DispatchQueue.main.async {
                        soundId = UInt32(self.idLabel.text ?? "") ?? 1000
                        try? AudioServicesPlaySystemSound(SystemSoundID(soundId))
                        self.idLabel.text = String((UInt32(self.idLabel.text ?? "") ?? 0) + 1)
                    }
                    usleep(1 * 100000)//0.1s
                }
                DispatchQueue.main.async {
                    self.idLabel.text = self.idTxf.text
                }
            }
        } catch {
            print("fail")
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        pan.cancelsTouchesInView = false
        view.addGestureRecognizer(pan)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
