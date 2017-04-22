//
// Created by Alexander Tkachenko on 22/04/17.
// Copyright (c) 2017 Alexander Tkachenko. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {

    var name: String = ""


    public required init(_ name: String) {
        self.name = name
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            return nil
        }
        self.init(name)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }


}