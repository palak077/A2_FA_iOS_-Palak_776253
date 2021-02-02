//
//  ProductTableViewController.swift
//  A2_FA_iOS_Gagandeep_C0764922
//
//  Created by Gagandeep on 1/31/21.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segment: UISegmentedControl!
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products : [Product] = []
    var provider : [Provider] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getProducts()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        change(self)
    }
    func getProducts(){
        products = []
        products = try! context.fetch(Product.fetchRequest())
        insertProducts()
        tableView.reloadData()
    }
    func insertProducts()
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

            getProducts()
        }
    }
    //Final exam
    @IBAction func change(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            getProducts()
            searchBar.isHidden = false
        }
        else{
            getProvider()
            searchBar.isHidden = true
        }
    }
    @IBAction func add(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: self)
        }
        else{
            performSegue(withIdentifier: "addProvider", sender: self)
        }
    }
    func getProvider(){
        provider = []
        provider = try! context.fetch(Provider.fetchRequest())
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? String{
            if segment.selectedSegmentIndex == 0{
                let vc = segue.destination as! AddProductTableViewController
                vc.selectedProduct = products[tableView.indexPathForSelectedRow!.row]
            }
            else{
                let vc = segue.destination as! GetProductsTableViewController
                vc.selectedProvider = provider[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if segment.selectedSegmentIndex == 0{
            return products.count
        }
        else{
            return provider.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if segment.selectedSegmentIndex == 0{
            cell.textLabel?.text =
                products[indexPath.row].productName
            cell.detailTextLabel?.text = products[indexPath.row].provider?.provider
        }
        else{
            cell.textLabel?.text =
                provider[indexPath.row].provider
            let req : NSFetchRequest<Product> = Product.fetchRequest()
            //req.predicate =  NSPredicate(format: "provider = '\(provider[indexPath.row].provider!)'")
            let productz = try! context.fetch(req)
            var count = 0
            for pro in productz{
                if pro.provider?.provider == provider[indexPath.row].provider{
                    count = count + 1
                }
            }
            cell.detailTextLabel?.text = count.description
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: "me")
        }
        else{
            performSegue(withIdentifier: "getProduct", sender: "me")
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if segment.selectedSegmentIndex == 0{
                let pro = products[indexPath.row]
                context.delete(pro)
            }
            else{
                for prod in products{
                    if prod.provider == provider[indexPath.row]{
                        context.delete(prod)
                    }
                }
                let pro = provider[indexPath.row]
                context.delete(pro)
                
            }
            try! context.save()
            change(self)
            
        }
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
            getProducts()
            
        }
        tableView.reloadData()
    }
}
