//
//  CategoryTableViewController.swift
//  To do list app
//
//  Created by Arturs Vitins on 11/02/2018.
//  Copyright © 2018 Arturs Vitins. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    


    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 90.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
           // cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.cellColor) else {fatalError()}

           // cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].cellColor) ?? "1D9BF6")

            cell.backgroundColor = UIColor(hexString: category.cellColor)
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        
        
        
        
        return cell
    }
 
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCat = Category()
            newCat.name = textField.text!
            newCat.cellColor = UIColor.randomFlat.hexValue()
            
            self.saveCategory(category: newCat)
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategory(category: Category) {
        
        
        do{
            
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
   // func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.categories?[indexPath.row] {

            do {
                try self.realm.write {

                    self.realm.delete(item)
                }
            } catch{
                print(error)
            }
        }
        
    }

}






