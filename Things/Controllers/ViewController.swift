//
//  ViewController.swift
//  Things
//
//  Created by Rodrigo Colozio on 28/04/23.
//

import UIKit

class ViewController: UIViewController {
    

    // MARK: - IBOutelts
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: - Atributtes
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var list: [Itens] = []
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchItens()
    }
    
    // MARK: - Methods
    func fetchItens() {
        do {
            self.list =  try context.fetch(Itens.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        } catch let error as NSError{
            print("Could not fetch your item \(error)")
        }
    }

    // MARK: - IBActions
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add a Thing", message: "Please add a To Do", preferredStyle: .alert)
        alert.addTextField()
        
        // submit button
        alert.addAction(UIAlertAction(title: "Add", style: .default){ (action) in
            let textField = alert.textFields![0]
            
            let newItem = Itens(context: self.context)
            newItem.item = textField.text
            
            do {
                try self.context.save()

            } catch let error as NSError{
                print("Could not save your item to the list \(error)")
            }
            
            self.fetchItens()
            
        })
        present(alert, animated: true)
    }
    
}


    // MARK: - UITableViewDataSource and UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let item = self.list[indexPath.row]
        
        cell.textLabel?.text = item.item
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = self.tableView.cellForRow(at: indexPath) else { return }
        
        if row.accessoryType == .none {
            row.accessoryType = .checkmark
        } else {
            row.accessoryType = .none
        }
    }
    
    
    // creating delete function with swipe gesture
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let itemToRemove = self.list[indexPath.row]
            
            self.context.delete(itemToRemove)
            
            do {
               try self.context.save()

            } catch let error as NSError{
                print("Could not delete the item from your list \(error)")
            }
            
            self.fetchItens()
            
        }
        return UISwipeActionsConfiguration (actions: [action])
    }
    
    
}

