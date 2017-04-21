//
//  LoginController.swift
//  Quiz
//
//  Created by Alexander Tkachenko on 20/04/17.
//  Copyright (c) 2017 Alexander Tkachenko. All rights reserved.
//

import UIKit
import Firebase


class LoginController: UIViewController {

    @IBOutlet weak var textFieldEmail: PaddingTextField!
    @IBOutlet weak var textFieldPassword: PaddingTextField!
    @IBOutlet weak var buttonSingUpLogin: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onEmailChanged(_ sender: UITextField) {
        updateButtonEnabling()
    }

    @IBAction func onPasswordChanged(_ sender: UITextField) {
        updateButtonEnabling();
    }

    private func updateButtonEnabling() {
        guard let email = textFieldEmail.text, email.characters.count >= 5 else {
            buttonSingUpLogin.isEnabled = false
            return
        }
        guard let password = textFieldPassword.text, password.characters.count >= 6 else {
            buttonSingUpLogin.isEnabled = false
            return
        }
        buttonSingUpLogin.isEnabled = true
    }

    @IBAction func onSignUpLoginClicked(_ sender: Any) {
        let email = textFieldEmail.text!
        let pass = textFieldPassword.text!
        singIn(withEmail: email, password: pass)
    }


    // TODO: move to AuthManager
    // authentication

    func singIn(withEmail: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password) { (user, error) in
            if let error = error {
                if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .errorCodeUserNotFound:
                        self.signUp(withEmail: withEmail, password: password)
                    default:
                        print("Create User Error: \(error)")
                        self.showAlert(error.localizedDescription)
                    }
                }
                return
            }

            if let user = user {
                self.onUserLoggedIn(user)
            } else {
                print("User is null")
            }
        }
    }

    func signUp(withEmail: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { (user, error) in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }

            if let user = user {
                self.onUserLoggedIn(user)
            } else {
                print("User is null")
            }
        }
    }

    func onUserLoggedIn(_ user: FIRUser) {
        // TODO: save user, token, etc
        // TODO: open next screen!
    }


    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Authentication error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}
