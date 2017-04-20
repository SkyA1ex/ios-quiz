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
        // TODO:
        buttonSingUpLogin.isEnabled = !buttonSingUpLogin.isEnabled;
        // if (sender.text?.characters.count > 0)
    }

    @IBAction func onPasswordChanged(_ sender: UITextField) {
        // TODO:
    }
    
    @IBAction func onSignUpLoginClicked(_ sender: Any) {
//        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
//            // ...
//        }
    }
    



}
