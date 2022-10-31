//
//  ViewController.swift
//  Project7
//
//  Created by ROHIT DAS on 22/08/22.
//

import UIKit

class ViewController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating{
    
    
    
    @IBOutlet var myTable: UITableView!
    var petitions = [Petition]()
    var searching = false
    var searchedPetitions = [Petition]()
    let searchController = UISearchController(searchResultsController: nil)
         


    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search petitions"

        
        
        
        
        
        
        
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }
    }
        func showError() {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
                self.tableView.reloadData()
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchedPetitions.count
        }
        else{
            return petitions.count
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var cellConfigurator = cell.defaultContentConfiguration()
        if searching{
            let searchedpetition = searchedPetitions[indexPath.row]
            cellConfigurator.text = searchedpetition.title
            cellConfigurator.textProperties.numberOfLines = 1
            cellConfigurator.secondaryText = searchedpetition.body
            cellConfigurator.secondaryTextProperties.numberOfLines = 1

            cell.contentConfiguration = cellConfigurator
            return cell
        }
        
        else{
            let petition = petitions[indexPath.row]
            cellConfigurator.text = petition.title
            cellConfigurator.textProperties.numberOfLines = 1
            
            cellConfigurator.secondaryText = petition.body
            cellConfigurator.secondaryTextProperties.numberOfLines = 1
            
            cell.contentConfiguration = cellConfigurator
            
            return cell
            
        }
        
           
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapCredits(_ sender: Any) {
        let credits = UIAlertController(title: "Credits", message: "the data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        credits.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(credits, animated: true)
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty{
            searching = true
            searchedPetitions.removeAll()
            for petition in petitions{
                if petition.title.lowercased().contains(searchText.lowercased()){
                    searchedPetitions.append(petition)
                }
            }
        }
        else{
            searching = false
            searchedPetitions.removeAll()
            searchedPetitions = petitions
        }
        myTable.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedPetitions.removeAll()
        myTable.reloadData()
    }
    
    
}
