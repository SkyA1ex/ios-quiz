//
//  MainController.swift
//  QuizApp
//
//  Created by Alexander Tkachenko on 21/04/17.
//  Copyright © 2017 Alexander Tkachenko. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MainController: UIViewController {


    @IBOutlet weak var fetchQuizButton: UIButton!
    @IBOutlet weak var quizQuestionLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkUserSignedId()
    }

    func checkUserSignedId() {
        if FIRAuth.auth()?.currentUser == nil {
            // user is not signed in
            goToLoginController()
        }
    }



    @IBAction func fetchQuizClicked(_ sender: UIButton) {
        // TODO:
    }

    @IBAction func logoutClicked(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        goToLoginController()
    }

    func goToLoginController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "loginController") as! LoginController
        self.present(loginController, animated: true, completion: nil)
    }

}
