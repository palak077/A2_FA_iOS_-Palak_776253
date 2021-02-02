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
            firstProvider.provider = "Cars"
            
            let pro1 = Product(context: context)
            pro1.productDesc = "Best possible speed out there "
            pro1.productID = "C1"
            pro1.productName = "Jaguar"
            pro1.productPrice = "2000"
            pro1.provider = firstProvider
            
            let pro2 = Product(context: context)
            pro2.productDesc = "well suited for the joint family and budget oriented "
            pro2.productID = "C2"
            pro2.productName = "Honda Civic"
            pro2.productPrice = "2500"
            pro2.provider = firstProvider
            
            let secondProvider = Provider(context: context)
            secondProvider.provider = "Tommy hilfiger"
            
            let pro3 = Product(context: context)
            pro3.productDesc = "best for wearing while exercise"
            pro3.productID = "T1"
            pro3.productName = "Shoes"
            pro3.productPrice = "100"
            pro3.provider = secondProvider
            
            let pro4 = Product(context: context)
            pro4.productDesc = "best for wearing while exercise"
            pro4.productID = "T2"
            pro4.productName = "Track suit"
            pro4.productPrice = "300"
            pro4.provider = secondProvider
            
            let thirdProvider = Provider(context: context)
            thirdProvider.provider = "Nestle"
            
            let pro5 = Product(context: context)
            pro5.productDesc = "Coffee releives stress"
            pro5.productID = "N1"
            pro5.productName = "Coffee"
            pro5.productPrice = "20"
            pro5.provider = thirdProvider
            
            let pro6 = Product(context: context)
            pro6.productDesc = "Eat day and night, so tasty"
            pro6.productID = "N2"
            pro6.productName = "Noodles"
            pro6.productPrice = "15"
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
