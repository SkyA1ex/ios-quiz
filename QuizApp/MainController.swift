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
import FirebaseDatabase


class MainController: UIViewController {


    @IBOutlet weak var fetchQuizButton: UIButton!
    @IBOutlet weak var quizQuestionLabel: UILabel!


    var dataManager: DataManager!


    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkUserSignedId()
    }



    // clicks

    @IBAction func fetchQuizClicked(_ sender: UIButton) {
//        dataManager.fetchAllQuizzes(with: { (quizzes) in
//            self.quizQuestionLabel.text = quizzes[1].answer4
//        })

        dataManager.sendAnswer(quizId: 10, answerNumber: 2, with: { (error) in
            if let error = error {
                Utils.showAlert(self, "Error while sending an answer", error.localizedDescription)
            }
        })

    }



    // authorization

    func checkUserSignedId() {
        if FIRAuth.auth()?.currentUser == nil {
            // user is not signed in
            goToLoginController()
        }
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
