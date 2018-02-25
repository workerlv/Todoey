//
//  Category.swift
//  To do list app
//
//  Created by Arturs Vitins on 18/02/2018.
//  Copyright © 2018 Arturs Vitins. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let item = List<Items>()
    
}
