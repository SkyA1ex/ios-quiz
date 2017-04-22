//
// Created by Alexander Tkachenko on 21/04/17.
// Copyright (c) 2017 Alexander Tkachenko. All rights reserved.
//

import Foundation


class Quiz: NSObject, NSCoding {

    var id: Int?
    var question: String?
    var answer1, answer2, answer3, answer4: String?


    public required convenience init(coder decoder: NSCoder) {
        self.init()
        id = decoder.decodeInteger(forKey: "id")
        question = decoder.decodeObject(forKey: "question") as? String
        answer1 = decoder.decodeObject(forKey: "answer1") as? String
        answer2 = decoder.decodeObject(forKey: "answer2") as? String
        answer3 = decoder.decodeObject(forKey: "answer3") as? String
        answer4 = decoder.decodeObject(forKey: "answer4") as? String
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(question, forKey: "question")
        coder.encode(answer1, forKey: "answer1")
        coder.encode(answer2, forKey: "answer2")
        coder.encode(answer3, forKey: "answer3")
        coder.encode(answer4, forKey: "answer4")
    }

    public static func parseDictionary(data: NSDictionary) -> Quiz? {
        var quiz = Quiz()

        guard let id = data["id"] as? Int,
              let question = data["question"] as? String,
              let answer1 = data["answer_1"] as? String,
              let answer2 = data["answer_2"] as? String,
              let answer3 = data["answer_3"] as? String,
              let answer4 = data["answer_4"] as? String else {
            return nil
        }

        quiz.id = id
        quiz.question = question
        quiz.answer1 = answer1
        quiz.answer2 = answer2
        quiz.answer3 = answer3
        quiz.answer4 = answer4

        return quiz
    }

}