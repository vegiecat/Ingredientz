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
        fetchRequest.shouldRefreshRefetchedObjects = true
        fetchRequest.includesPendingChanges = false
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
    
    func reloadRecipeOfInterest(){
        println("----------------Helper reloadRecipeOfInterest()----------------")
        println("recipeOfInterest BEFORE reload:\(recipeOfInterest)")
        //if let recipe = recipeOfInterest{
            globalMOC.refreshObject(recipeOfInterest!, mergeChanges: true)
            
//            let fetchRequest = NSFetchRequest(entityName: EntityNames.Recipe)
//            fetchRequest.predicate = NSPredicate(format: "id = %@", recipe.id)
//            var error:NSError?
//            let fetchResult = globalMOC.executeFetchRequest(fetchRequest, error: &error) as? [Recipe]
//            if error != nil{
//                println(error)
//            }
//
//            if let result = fetchResult{
//                recipeOfInterest = result.first
//                println(result)
//            }else{
//                println("There was an Problem with fetchAllRecipesByUser()")
//            }
        //}
        println("recipeOfInterest AFTER reload:\(recipeOfInterest)")
        
//        let recipes = fetchAllRecipesByUser()
//        let newRecipe = recipes.filter{$0.id == self.recipeOfInterest?.id}.first
//        recipeOfInterest = nil
//        recipeOfInterest = newRecipe
    }
    
    //MARK: Managing Recipes
    func newRecipe()->Recipe{
        let entity = NSEntityDescription.entityForName(EntityNames.Recipe, inManagedObjectContext: globalMOC)
        let recipe = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: globalMOC) as! Recipe
        return recipe
    }
    
    func deleteRecipe(recipe:Recipe){
        globalMOC.deleteObject(recipe)
        save()
        reloadRecipeOfInterest()
    }

    func newIngr()->Ingr{
        let entity = NSEntityDescription.entityForName(EntityNames.Ingredient, inManagedObjectContext: globalMOC)
        let ingredient = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: globalMOC) as! Ingr
        if let recipe = recipeOfInterest{
            ingredient.recipe = recipe
            ingredient.order = recipe.ingr.count
        }
        return ingredient
    }

    func deleteIngr(ingrdient:Ingr){
        globalMOC.deleteObject(ingrdient)
        println("*********************************************************************")
        println("deleteIngr excuted")
        save()
        reloadRecipeOfInterest()

    }

    
    func didSelectRecipe(recipeSeleted:Recipe, sender:AnyObject?){
        recipeOfInterest = recipeSeleted
    }
    
    func recipeOfInterest(sender:AnyObject?)->Recipe?{
        reloadRecipeOfInterest()
        return recipeOfInterest
    }
    
    //MARK: Core Data Connectivity
    class func managedObjectContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext!
        return managedObjectContext
    }

    func save2(){
        println("save2 triggered")
        var error: NSError? = nil
        globalMOC.save(&error)
        println("error from save2:\(error)")
        reloadRecipeOfInterest()
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