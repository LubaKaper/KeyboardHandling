//
//  ViewController.swift
//  KeyboardHandling
//
//  Created by Liubov Kaper  on 2/3/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var pursuitLogo: UIImageView!
    

    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var pursuitLogoCenterYConstraint: NSLayoutConstraint!
    
    private var originalYConstraint: NSLayoutConstraint!
    
    private var keyboardIsVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        
        usernameTextField.delegate = self
               passwordTextField.delegate = self
        
        pulsateLogo()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyboardNotification()
       
    }
    
    

    private func registerForKeyboardNotifications() {
        //singleton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   @objc private func keyboardWillShow(_ notification: NSNotification) {
    //print("keyboardWillShow")
    
   // UIKeyboardFrameBeginUserInfoKey
    guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
        return
    }
    moveKeyboardUp(keyboardFrame.size.height)
    
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        resetUI() 
    }
    
    private func moveKeyboardUp(_ height: CGFloat) {
        if keyboardIsVisible {return}
        originalYConstraint = pursuitLogoCenterYConstraint // save original value
        print(originalYConstraint.constant)
        pursuitLogoCenterYConstraint.constant -= (height * 0.80)
         
        // animation for sign to move smooth
        UIView.animate(withDuration: 0.5) {// could use usingSpringWithDamping for bounce
            self.view.layoutIfNeeded()
        }
        keyboardIsVisible = true
    }
    
     // animation for sign to move smooth

    private func resetUI() {
        keyboardIsVisible = false
          
        pursuitLogoCenterYConstraint.constant -= originalYConstraint.constant
        
        // animation, logo goes down
        UIView.animate(withDuration: 1.0){
            self.view.layoutIfNeeded()
        }
        
    }
    private func pulsateLogo() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.pursuitLogo.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
        }
    }


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        resetUI()
        return true
    }
}
