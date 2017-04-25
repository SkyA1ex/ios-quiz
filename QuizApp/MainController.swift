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

    @IBOutlet weak var buttonCircle: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var quizQuestionLabel: UILabel!
    @IBOutlet weak var labelEmpty: UILabel!

    @IBOutlet weak var buttonAnswer1: UIButton!
    @IBOutlet weak var buttonAnswer2: UIButton!
    @IBOutlet weak var buttonAnswer3: UIButton!
    @IBOutlet weak var buttonAnswer4: UIButton!

    @IBOutlet weak var labelLoading: UILabel!
    @IBOutlet weak var labelAnswer1: UILabel!
    @IBOutlet weak var labelAnswer2: UILabel!
    @IBOutlet weak var labelAnswer3: UILabel!
    @IBOutlet weak var labelAnswer4: UILabel!
    @IBOutlet weak var layoutButtons: UIView!

    var dataManager: DataManager!
    var currentQuizIndex: Int?
    var currentQuizId: Int?
    var quizzes: [Quiz]?


    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (checkUserSignedId()) {
            start()
        }
    }

    private func start() {
        showMainLoader(isShown: true)
        // dataManager.getCachedQuizzesAsync(with: self.setQuizzes)
        dataManager.fetchAllQuizzes(with: self.setQuizzes, withError: { (error) in
            self.showMainLoader(isShown: false)
            self.showError(title: "Can't load quizzes", error: error?.localizedDescription)
        })
    }


    // UI methods

    private func setQuizzes(newQuizzes: [Quiz]) {
        showMainLoader(isShown: false)
        if (newQuizzes.count > 0) {
            quizzes = newQuizzes
            currentQuizIndex = 0
            currentQuizId = quizzes![0].id
            showQuiz(quizzes![0])
        } else {
            showNoQuizzes()
        }
    }

    private func showError(title: String?, error: String?) {
        Utils.showAlert(self, title, error)
    }

    private func showNoQuizzes() {
        animateViewHide(buttonSkip)
        animateViewHide(quizQuestionLabel)
        animateViewHide(layoutButtons)
        animateViewShow(labelEmpty)
    }

    private func showMainLoader(isShown: Bool) {
        if isShown {
            quizQuestionLabel.isHidden = true
            layoutButtons.isHidden = true
            buttonSkip.isHidden = true
            animateViewShow(labelLoading)
        } else {
            // animate buttons layout
            animateViewShow(layoutButtons)
            animateViewShow(quizQuestionLabel)
            animateViewShow(buttonSkip)
            animateViewHide(labelLoading)
        }
    }

    private func showAnsweringLoader(isShow: Bool) {
        // TODO: add loader
        // enable/disable answer buttons
        buttonAnswer1.isEnabled = !isShow
        buttonAnswer2.isEnabled = !isShow
        buttonAnswer3.isEnabled = !isShow
        buttonAnswer4.isEnabled = !isShow
        buttonSkip.isEnabled = !isShow
    }

    private func showQuiz(_ quiz: Quiz) {
        // TODO add animation
        quizQuestionLabel.text = quiz.question
        labelAnswer1.text = quiz.answer1
        labelAnswer2.text = quiz.answer2
        labelAnswer3.text = quiz.answer3
        labelAnswer4.text = quiz.answer4
    }

    private func showNextQuiz() {
        guard let quizzes = quizzes,
              let quizIndex = currentQuizIndex else {
            print("showNextQuiz: error")
            return
        }

        if quizIndex + 1 <= quizzes.count - 1 {
            currentQuizIndex! += 1 // can I use quizIndex here?
            let nextQuiz = quizzes[currentQuizIndex!]
            currentQuizId = nextQuiz.id
            showQuiz(nextQuiz)
        } else {
            showNoQuizzes()
            currentQuizIndex = nil
            currentQuizId = nil
        }
    }


    // clicks

    @IBAction func answerClicked(_ sender: UIButton) {
        var answer: Int;
        switch sender {
        case buttonAnswer1:
            answer = 1
        case buttonAnswer2:
            answer = 2
        case buttonAnswer3:
            answer = 3
        case buttonAnswer4:
            answer = 4
        default:
            print("wrong tag")
            return
        }

        showAnsweringLoader(isShow: true)
        dataManager.sendAnswer(quizId: currentQuizId!, answerNumber: answer, with: { (error) in
            self.showAnsweringLoader(isShow: false)
            if (error == nil) {
                // sent successfully
                self.showNextQuiz()
            } else {
                // error occurred
                self.showError(title: "Sending answer error", error: error?.localizedDescription)
            }
        })
    }

    @IBAction func skipClicked(_ sender: UIButton) {
        dataManager.saveQuizAsSkippedToLocal(quizId: currentQuizId!)
        showNextQuiz()
    }



    // buttons animation

    @IBAction func buttonTochedDown(_ sender: UIButton) {
        animateButtonDark(sender)
    }

    @IBAction func buttonTochedUpOutside(_ sender: UIButton) {
        animateButtonLight(sender)
    }


    private func animateButtonDark(_ button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            button.backgroundColor = UIColor.init(redInt: 0, blueInt: 0, greenInt: 0, alpha: 0.4)
        }
    }

    private func animateButtonLight(_ button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            button.backgroundColor = UIColor.init(redInt: 0, blueInt: 0, greenInt: 0, alpha: 0)
        }
    }



    // authorization

    func checkUserSignedId() -> Bool {
        if FIRAuth.auth()?.currentUser == nil {
            // user is not signed in
            goToLoginController()
            return false
        }
        return true
    }

    @IBAction func logoutClicked(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        dataManager.clearCache()
        goToLoginController()
    }

    func goToLoginController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "loginController") as! LoginController
        self.present(loginController, animated: true, completion: nil)
    }


    // other

    private func animateViewHide(_ view: UIView) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            view.alpha = 0
        }, completion: { finished in
            // nothing for now
            view.isHidden = true
            view.alpha = 1
        })
    }

    private func animateViewShow(_ view: UIView) {
        if view.alpha == 1 {
            view.alpha = 0
        }
        view.isHidden = false
        UIView.animate(withDuration: 1.5, delay: 0, options: [], animations: {
            view.alpha = 1
        }, completion: { finished in
            // nothing for now
        })
    }


    // button circle

    @IBAction func onCircleUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 2) {
            sender.bounds.size.width *= 2
        }
    }

}
