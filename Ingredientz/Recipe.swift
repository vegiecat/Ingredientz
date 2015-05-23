//
//  Recipe.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/15/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import Foundation
import CoreData

@objc(Recipe)
class Recipe: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var ingr: NSOrderedSet
    @NSManaged var order: Int
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        id = NSUUID().UUIDString
        name = ""
    }
    
    override func awakeFromFetch() {
        super.awakeFromFetch()
        var ingredientArray = ingr.array as! [Ingr]
        ingredientArray.sort{$0.order < $1.order}
        ingr = NSOrderedSet(array: ingredientArray)
    }
    
    override var description : String{
        let ingrNames = "\(ingr.array.map{$0.name})"
        var returnString = "Name:\(name) \n" + ingrNames
        return returnString
    }
    
}
