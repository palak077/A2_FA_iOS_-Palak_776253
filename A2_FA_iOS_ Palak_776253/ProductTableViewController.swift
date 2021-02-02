//
//  ProductTableViewController.swift
//
//  A2_FA_iOS_ Palak_776253
//
//  Created by Macbook on 2021-02-01.
//
import UIKit
import CoreData

class ProductsViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var products : [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    func loadData()
    {
        products = []
        products = try! context.fetch(Product.fetchRequest())
        enterData()
        tableView.reloadData()
    }
    //MARK: - enter the data into the file
    func enterData()
    {
        if products.count == 0
        {
            let firstProvider = Provider(context: context)
            firstProvider.provider = "Tata"
            
            let pro1 = Product(context: context)
            pro1.productDesc = "salty"
            pro1.productID = "001"
            pro1.productName = "salt"
            pro1.productPrice = "100"
            pro1.provider = firstProvider
            
            let pro2 = Product(context: context)
            pro2.productDesc = "skyyy"
            pro2.productID = "002"
            pro2.productName = "sky"
            pro2.productPrice = "300"
            pro2.provider = firstProvider
            
            let secondProvider = Provider(context: context)
            secondProvider.provider = "Suzuki"
            
            let pro3 = Product(context: context)
            pro3.productDesc = "p1dis"
            pro3.productID = "001"
            pro3.productName = "bike"
            pro3.productPrice = "100"
            pro3.provider = secondProvider
            
            let pro4 = Product(context: context)
            pro4.productDesc = "p1dis"
            pro4.productID = "002"
            pro4.productName = "car"
            pro4.productPrice = "300"
            pro4.provider = secondProvider
            
            let thirdProvider = Provider(context: context)
            thirdProvider.provider = "BMW"
            
            let pro5 = Product(context: context)
            pro5.productDesc = "p1dis"
            pro5.productID = "001"
            pro5.productName = "bike"
            pro5.productPrice = "100"
            pro5.provider = thirdProvider
            
            let pro6 = Product(context: context)
            pro6.productDesc = "p1dis"
            pro6.productID = "002"
            pro6.productName = "car"
            pro6.productPrice = "300"
            pro6.provider = thirdProvider
 
            try! context.save()
            loadData()
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return products.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
            cell.textLabel?.text =
                products[indexPath.row].productName
            cell.detailTextLabel?.text = products[indexPath.row].provider?.provider
       
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "productName contains[c] '\(searchText)' || productDesc contains[c] '\(searchText)'")
            let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                products = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        else{
            loadData()
            
        }
        tableView.reloadData()
    }
}
