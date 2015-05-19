//
//  Ingr.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/15/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import Foundation
import CoreData

@objc(Ingr)
class Ingr: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var qty: String
    @NSManaged var recipe: Recipe

    override func awakeFromInsert() {
        super.awakeFromInsert()
        id = NSUUID().UUIDString
        name = ""
        qty = ""
    }

}
