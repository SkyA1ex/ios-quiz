//
//  DataManager.swift
//  QuizApp
//
//  Created by Alexander Tkachenko on 21/04/17.
//  Copyright © 2017 Alexander Tkachenko. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class DataManager {

    private struct Path {
        static let testQuiz = "quiz_test"
        static let publicQuizzes = "public_quizzes"
        static func answerQuiz(userId: String, quizId: Int) -> String {
            return "users/\(userId)/answers/\(quizId)"
        }
    }

    var firebase: FIRDatabaseReference!

    init() {
        firebase = FIRDatabase.database().reference()
    }


    func fetchTestQuiz(with: ((_: Quiz) -> ())?) {
        firebase.child(Path.testQuiz).observeSingleEvent(of: .value,
                with: { (snap) in
                    guard let value = snap.value as? NSDictionary else {
                        print("fetchTestQuiz: data is nil")
                        return
                    }

                    let quiz = Quiz.parseDictionary(data: value)

                    if quiz != nil {
                        // TODO: save to local database
                        with?(quiz!)
                    } else {
                        print("fetchTestQuiz: quiz parsing error")
                    }
                },
                withCancel: { (error) in
                    print("fetchTestQuiz: " + error.localizedDescription)
                })
    }

    func fetchAllQuizzes(with: ((_: [Quiz]) -> ())?) {
        firebase.child(Path.publicQuizzes).observeSingleEvent(of: .value,
                with: { (snap) in
                    var results = [Quiz]()
                    guard let values = snap.value as? NSArray else {
                        print("fetchAllQuizzes: data is nil")
                        return
                    }

                    for value in values {
                        guard let value = value as? NSDictionary else {
                            print("fetchAllQuizzes: array item is nil")
                            continue
                        }
                        let quiz = Quiz.parseDictionary(data: value)

                        if quiz != nil {
                            results.append(quiz!)
                        } else {
                            print("fetchAllQuizzes: couldn't parse array item")
                        }
                    }

                    // TODO: save to local datebase
                    with?(results)
                },
                withCancel: { (error) in
                    print("fetchAllQuizzes: " + error.localizedDescription)
                })
    }

    func sendAnswer(quizId: Int, answerNumber: Int, with: ((_: Error?) -> ())?) {
        guard let user = FIRAuth.auth()?.currentUser else {
            print("user is not logged in")
            with?(nil)
            return
        }

        // set value ../users/{user_id}/answers/{quiz_id} to {answer}
        firebase.child(Path.answerQuiz(userId: user.uid, quizId: quizId))
                .setValue(answerNumber, withCompletionBlock: { (error, _) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // TODO: save quiz ID to list of answered
                    }
                    with?(error)
                })
    }


}
