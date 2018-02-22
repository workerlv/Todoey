//
//  Items.swift
//  To do list app
//
//  Created by Arturs Vitins on 18/02/2018.
//  Copyright © 2018 Arturs Vitins. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?

    var parentCategory = LinkingObjects(fromType: Category.self, property: "item")
    
}
