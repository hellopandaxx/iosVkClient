//
//  LoginFormController.swift
//  LoginForm
//
//  Created by Sergey Kuznetsov on 24/03/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)),  name:  NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*@IBAction func loginButtonPressed(_ sender: Any) {
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "admin" && password == "123456"{
        print("success authorization")
        } else {
            print("authorization failed")
        }
    }*/
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        let loginResult = checkUserData()
//
//        if !loginResult{
//            showLoginError()
//        }
//
//        return loginResult
        
        return true
    }
    
    func checkUserData() -> Bool {
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "admin" && password == "123456"{
            return true
        } else {
            return false
        }
    }
    
    func showLoginError(){
        let alter = UIAlertController(title: "Error", message: "Wrong credentials", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alter.addAction(action)
        
        present(alter, animated: true, completion: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification){
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification){
        let contentInsets = UIEdgeInsets.zero
        
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard(){
        scrollView?.endEditing(true)
    }
}
