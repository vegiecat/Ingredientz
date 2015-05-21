//
//  RecipeDetailTVC.swift
//  Ingredientz
//
//  Created by Vegiecat Studio on 5/19/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit

class RecipeDetailTVC: UITableViewController {

    private struct SegueID{
        static let ID1 = "xxx"
        static let ID2 = "yyy"
    }
    private struct Cells{
        static let RecipeDetailGeneral = "Recipe Detail Cell"
        static let IngredientItemCell = "Ingredient Item Cell"
    }
    private struct SectionTitles{
        static let name = "Name"
        static let ingredients = "Ingredients"
    }

    var dataSource:IngredientzCoreDataHelper?{
        didSet{
            println("dataSource got set")
        }
    }
    
    // Public API
    var recipe:Recipe?{
        didSet{
            println("Recipe got Set.")
            recipeContents.append(RecipeSection(title: SectionTitles.name, recipeItems:[RecipeItem.name(recipe!.name)] ))
            let ingrdientsArray = recipe!.ingr.array as! [Ingr]
            //let test = ingrdientsArray.map{(ingr:Ingr)->String in return ingr.name}
            let ingredients = RecipeSection(title: SectionTitles.ingredients, recipeItems: ingrdientsArray.map{RecipeItem.ingredient($0)})
            recipeContents.append(ingredients)
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
        case ingredient(Ingr)
        var description:String{
            get{
                switch self{
                case .name(let name):
                    return name
                case .ingredient(let ingredient):
                    return ingredient.name
                }
            }
        }
    }
    
    var isInEditMode = false
    
    @IBAction func addIngredient(sender: UIBarButtonItem) {
        ingredientEditAlert(nil)
//        if let ds = dataSource{
//            var window = UIAlertController(title: "New Recipe", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
//                let textField = window.textFields![0] as! UITextField
//                var newIngredient = ds.newIngr()
//                newIngredient.name = textField.text
//                ds.save()
////                let tempIngr = recipe?.ingr as! NSMutableOrderedSet
////                tempIngr.addObject(newIngredient)
////                ingredientEditAlert(newIngredient)
//                self.refresh()
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in}
//            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
//                textField.text = ""
//                textField.placeholder = "Ingredient"
//            }
//            window.addAction(saveAction)
//            window.addAction(cancelAction)
//            presentViewController(window, animated: true, completion: nil)
//        }
    }
    
    @IBAction func didTapEditBtn(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        self.tableView.setEditing(isInEditMode, animated: true)
    }
    
    
    //code needs to be modulaized in a later phase.
    func ingredientEditAlert(ingredient:Ingr?){
        if let ds = dataSource{
            var window = UIAlertController(title: "Edit Ingredient", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
                let txtFieldName = window.textFields![0] as! UITextField
                let txtFieldQty = window.textFields![1] as! UITextField
                var ingredientEdited:Ingr?
                if let ingredientTemp = ingredient{
                    ingredientEdited = ingredientTemp
                }else{
                    ingredientEdited = ds.newIngr()
                }
                ingredientEdited?.name = txtFieldName.text
                ingredientEdited?.qty = txtFieldQty.text
                ds.save()
                self.refresh()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in}
            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
                textField.text = ingredient?.name ?? ""
                textField.placeholder = "Ingredient"
            }
            window.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
                textField.text = ingredient?.qty ?? ""
                textField.placeholder = "Quantity"
            }
            window.addAction(saveAction)
            window.addAction(cancelAction)
            presentViewController(window, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ds = dataSource{
            refresh()
        }
    }

    func refresh(){
        recipeContents.removeAll()
        recipe = dataSource?.recipeOfInterest(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return recipeContents.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeContents[section].recipeItems.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipeContents[section].title
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = recipeContents[indexPath.section].recipeItems[indexPath.row]
        switch item{
        case .name(let name):
            let cell = tableView.dequeueReusableCellWithIdentifier(Cells.RecipeDetailGeneral, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = name
            return cell
        case .ingredient(let ingredient):
            let cell = tableView.dequeueReusableCellWithIdentifier(Cells.IngredientItemCell, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = ingredient.name
            println("detailTextLabel:\(ingredient.qty)")
            
            cell.detailTextLabel?.text = ingredient.qty
            return cell
        }
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = recipeContents[indexPath.section].recipeItems[indexPath.row]
        switch item{
        case .name(let name):
            println("decide if we should let them edit name here")
        case .ingredient(let ingredient):
            ingredientEditAlert(ingredient)
            
        }
    }
    
    // MARK: - Table view data source, EDITING
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            if let ingredientSet = recipe?.ingr{
                if let ingredient = ingredientSet.objectAtIndex(indexPath.row) as? Ingr{
                    println(ingredient)
                    dataSource?.deleteIngr(ingredient)
                    
                    refresh()
                    println("ingredient deleted")
                }
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let ingredientSet = recipe?.ingr as! NSMutableOrderedSet
        //ingredientSet.exchangeObjectAtIndex(fromIndexPath.row, withObjectAtIndex: toIndexPath.row)
        ingredientSet.moveObjectsAtIndexes(NSIndexSet(index: fromIndexPath.row), toIndex: toIndexPath.row)
        let newIngredientSet = ingredientSet as NSOrderedSet
        recipe?.ingr = newIngredientSet
        dataSource?.save2()
        refresh()
    }

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
