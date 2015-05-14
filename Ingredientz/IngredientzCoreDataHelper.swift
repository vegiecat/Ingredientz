//
//  IngredientzCoreDataHelper.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/14/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit
import CoreData


class IngredientzCoreDataHelper: NSObject
{
    
//    var recipeOfInterest:Recipe?
//    let globalMOC:NSManagedObjectContext
//    
//    override init(){
//
//        super.init()
//        globalMOC = self.managedObjectContext()
//
//        
//    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: CoreDataConnectivity
    func managedObjectContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext!
        return managedObjectContext
    }
    
    
    
    
    
}
