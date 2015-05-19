//
//  RecipeDetailTVC.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/19/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit

class RecipeDetailTVCBackup: UITableViewController {
    
    private struct Storyboard{
        static let showRecipeDetail = "Show Recipe Detail"
        static let Identifier2 = "yyy"
    }
    private struct Cells{
        static let RecipeDetailGeneral = "Recipe Detail Cell"
        static let Identifier2 = "yyy"
    }
    private struct SectionTitles{
        static let name = "Name"
        static let ingredients = "Ingredients"
    }
    
    var dataSource:IngredientzCoreDataHelper?{
        didSet{
            println("i got set")
        }
    }
    
    // Public API
    var recipe:Recipe?{
        didSet{
            println("Recipe:\(recipe)")
            
            recipeContents.append(RecipeSection(title: SectionTitles.name, recipeItems:[RecipeItem.name(recipe!.name)] ))
            let ingrdientsArray = recipe!.ingr.array as! [Ingr]
            let test = ingrdientsArray.map{(ingr:Ingr)->String in return ingr.name}
            let temp = RecipeSection(title: SectionTitles.ingredients, recipeItems: ingrdientsArray.map{(ingr:Ingr)->RecipeItem in return RecipeItem.ingredient(ingr.name)})
            recipeContents.append(temp)
            tableView.reloadData()
        }
    }
    
    //Private Data Structure
    private var recipeContents:[RecipeSection] = []
    
    private struct RecipeSection{
        var title:String
        var recipeItems:[RecipeItem]
        var description:String{
            return "\(title):\(recipeItems)"
        }
    }
    
    private enum RecipeItem:Printable{
        //case photo(NSData,Double)
        case name(String)
        case ingredient(String)
        var description:String{
            get{
                switch self{
                case .name(let name):
                    return name
                case .ingredient(let ingredient):
                    return ingredient
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ds = dataSource{
            refresh()
        }
    }
    
    func refresh(){
        recipe = dataSource?.askedForRecipeOfInterest(self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        println(recipeContents.count)
        return recipeContents.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println(recipeContents[section].recipeItems.count)
        return recipeContents[section].recipeItems.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipeContents[section].title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = recipeContents[indexPath.section].recipeItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(Cells.RecipeDetailGeneral, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = item.description
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
