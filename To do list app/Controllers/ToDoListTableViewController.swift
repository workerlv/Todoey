//
//  ToDoListTableViewController.swift
//  To do list app
//
//  Created by Arturs Vitins on 05/02/2018.
//  Copyright © 2018 Arturs Vitins. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListTableViewController: SwipeTableViewController {

    var toDoItems: Results<Items>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard


    
    override func viewDidLoad() {
        super.viewDidLoad()        
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 90.0
        tableView.separatorStyle = .none

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name

        guard let colorHex = selectedCategory?.cellColor else { fatalError()}
        
        updateNavBar(withHexCode: colorHex)
            
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Nav bar setup methods
    
    func updateNavBar (withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller doeas not exist")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBarOutlet.barTintColor = navBarColor
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                
                 cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            //sis piecas rindas tiek aizstatas ar rindu virs
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        } else {
            //            cell.accessoryType = .none
            //        }
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
            
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                 
                   // realm.delete(item)
                    
                       item.done = !item.done
                }
            } catch{
                print(error)
            }
        }
        
        tableView.reloadData()

        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK - Add New Items
    
    @IBAction func addBtnPressedAction(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCatogry = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField.text!
                        currentCatogry.item.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch {
                    
                }
                
                
            }
    
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        
      
        
    }
    
    func loadItems() {

      toDoItems = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.toDoItems?[indexPath.row] {
            
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

extension ToDoListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        //toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
       toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()

            }
        }
    }


}










