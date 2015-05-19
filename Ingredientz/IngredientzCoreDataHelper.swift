//
//  IngredientzCoreDataHelper.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/15/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit
import CoreData

class IngredientzCoreDataHelper:NSObject
{
    
    var recipeOfInterest:Recipe?
    
    let globalMOC:NSManagedObjectContext = IngredientzCoreDataHelper.managedObjectContext()
    
    override init(){
        super.init()
    }
    

    //MARK: Fetch
    func fetchAllRecipesByUser()->[Recipe]{
        let fetchRequest = NSFetchRequest(entityName: EntityNames.Recipe)
        var error:NSError?
        
        let fetchResult = globalMOC.executeFetchRequest(fetchRequest, error: &error) as?[Recipe]
        if error != nil{
            println(error)
        }
        
        if let result = fetchResult{
            return result
        }else{
            println("There was an Problem with fetchAllRecipesByUser()")
            return []
        }
//        if let results = fetchResults{
//            let resultsArray = results.map{$0 as! Recipe}
//            println(resultsArray.map{"\($0.name):\($0.id)"})
//        }
    }
    
    //MARK: Managing Recipes
    func newRecipe()->Recipe{
        let entity = NSEntityDescription.entityForName(EntityNames.Recipe, inManagedObjectContext: globalMOC)
        let recipe = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: globalMOC) as! Recipe
        return recipe
    }
    
    
    //MARK: Core Data Connectivity
    class func managedObjectContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext!
        return managedObjectContext
    }

    func save(){
        var error: NSError? = nil
        if globalMOC.hasChanges && !globalMOC.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }

    
    
    
    
    
}