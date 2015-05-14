//
//  Recipe.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/14/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import Foundation
import CoreData

@objc(Recipe)
class Recipe: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var ingredient: NSOrderedSet
//    @NSManaged var step: NSOrderedSet
//    @NSManaged var coverPhoto: NSData
    
    
}
