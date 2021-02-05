/*
 * Copyright (C) Schweizerische Bundesbahnen SBB, 2017.
 */

import UIKit
import SwissPassClient

class DetailTableViewController: UITableViewController {

    var dataSource: Array<[String : AnyObject]> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "User profile"
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if let client = SwissPassClientManager.shared.loginClient {
            client.requestUserInfo(completionHandler: { (result) in
                switch result {
                case .failure(let error):
                    let alert = UIAlertController(title: "Request failed", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                case .success(let userInfo):
                    var array: Array<[String : AnyObject]> = Array()
                    let dict = userInfo.claims
                    for (key, value) in dict {
                        array.append([key: value])
                    }
                    self.dataSource = array
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)

        let entry = self.dataSource[indexPath.row]
        cell.textLabel?.text = entry.keys.first
        cell.detailTextLabel?.text = entry.values.first as! String?
        
        return cell
    }

}
