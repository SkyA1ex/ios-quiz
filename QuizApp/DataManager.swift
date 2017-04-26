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

    private struct Api {
        static let publicQuizzes = "public_quizzes"
        static func answerQuiz(userId: String, quizId: Int) -> String {
            return "users/\(userId)/answers/\(quizId)"
        }
    }

    private struct LocalPath {
        private static func directoryPath() -> URL {
            let manager = FileManager.default
            return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        static let publicQuizzes = directoryPath().appendingPathComponent("public_quizzes").path
        static let answers = directoryPath().appendingPathComponent("answers").path
    }

    var firebase: FIRDatabaseReference!

    init() {
        firebase = FIRDatabase.database().reference()
    }


    func fetchAllQuizzes(with: ((_: [Quiz]) -> ())?, withError: ((_: Error?) -> ())?) {
        firebase.child(Api.publicQuizzes).observeSingleEvent(of: .value,
                with: { (snap) in
                    // parse data async in background thread
                    DataManager.parseQuizzesAsync(spanshot: snap, with: { (quizzes) in
                        // filter already passed quizzes
                        let ids = self.getAnsweredIds()
                        let filteredQuizzes = quizzes.filter({quiz in !ids.contains(quiz.id!)})
                        // passing data to callback
                        with?(filteredQuizzes)
                        // saving to local database
                        self.saveQuizzesToLocalAsync(filteredQuizzes, with: nil)
                    })
                },
                withCancel: { (error) in
                    print("fetchAllQuizzes: " + error.localizedDescription)
                    withError?(error)
                })
    }

    func sendAnswer(quizId: Int, answerNumber: Int, with: ((_: Error?) -> ())?) {
        guard let user = FIRAuth.auth()?.currentUser else {
            print("user is not logged in")
            with?(nil)
            return
        }

        // set value of ../users/{user_id}/answers/{quiz_id} to {answer}
        firebase.child(Api.answerQuiz(userId: user.uid, quizId: quizId))
                .setValue(answerNumber, withCompletionBlock: { (error, _) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.saveNewAnswerToLocal(quizId: quizId, answerNumber: answerNumber)
                    }
                    with?(error)
                })
    }


    private static func parseQuizzesAsync(spanshot snap: FIRDataSnapshot, with: @escaping((_: [Quiz]) -> ())) {
        DispatchQueue.global(qos: .background).async {
            var results = [Quiz]()
            guard let values = snap.value as? NSArray else {
                print("parseQuizzesAsync: data is nil")
                return
            }

            for value in values {
                guard let value = value as? NSDictionary else {
                    print("parseQuizzesAsync: array item is nil")
                    continue
                }
                let quiz = Quiz.parseDictionary(data: value)

                if quiz != nil {
                    results.append(quiz!)
                } else {
                    print("parseQuizzesAsync: couldn't parse array item")
                }
            }

            DispatchQueue.main.async {
                with(results)
            }
        }
    }


    // local data


    // may be extended to save answer number
    private func saveNewAnswerToLocal(quizId: Int, answerNumber: Int) {
        DispatchQueue.global(qos: .background).async {
            var answers = NSKeyedUnarchiver.unarchiveObject(withFile: LocalPath.answers) as? [Int] ?? [Int]()
            answers.append(quizId)
            NSKeyedArchiver.archiveRootObject(answers, toFile: LocalPath.answers)
        }
    }

    public func saveQuizAsSkippedToLocal(quizId: Int) {
        saveNewAnswerToLocal(quizId: quizId, answerNumber: -1)
    }

    private func getAnsweredIds() -> [Int] {
        return NSKeyedUnarchiver.unarchiveObject(withFile: LocalPath.answers) as? [Int] ?? [Int]()
    }


    private func saveQuizzesToLocalAsync(_ quizzes: [Quiz], with: (() -> ())?) {
        DispatchQueue.global(qos: .background).async {
            NSKeyedArchiver.archiveRootObject(quizzes, toFile: LocalPath.publicQuizzes)
            with?()
        }
    }

    public func getCachedQuizzesAsync(with: @escaping (_: [Quiz]?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let quizzes = NSKeyedUnarchiver.unarchiveObject(withFile: LocalPath.publicQuizzes) as? [Quiz]
            DispatchQueue.main.async {
                with(quizzes)
            }
        }
    }

    public func clearCache() {
        do {
            try FileManager.default.removeItem(atPath: LocalPath.publicQuizzes)
            try FileManager.default.removeItem(atPath: LocalPath.answers)
        } catch let error {
            print("error while clearing cache: " + error.localizedDescription)
        }
    }


}
