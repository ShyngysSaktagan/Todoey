//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shyngys on 28/08/2019.
//  Copyright © 2019 Shyngys. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
         
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let category = Category()
             category.name = textField.text!
            self.save(category: category)
        }
        
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "add category name"
            textField = UITextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){

        categories = realm.objects(Category.self)
    }
    
    // MARK: - Table view data source
}
