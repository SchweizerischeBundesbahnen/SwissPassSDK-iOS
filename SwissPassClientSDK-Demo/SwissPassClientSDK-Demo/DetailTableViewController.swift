/*
 * Copyright (C) Schweizerische Bundesbahnen SBB, 2017.
 */

import UIKit
import SwissPassClient

internal enum Mode {
    case userInfo
    case user
}

class DetailTableViewController: UITableViewController {

    var dataSource: Array<[String : AnyObject]> = Array()
    var mode: Mode?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch mode {
        case .userInfo:
            self.navigationItem.title = "Benutzerprofil"
        case .user:
            self.navigationItem.title = "Identität"
        default:
            fatalError()
        }

        self.navigationItem.title = "User profile"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        switch mode {
        case .userInfo:
            loadUserInfo()
        case .user:
            displayIdentity()
        default:
            fatalError()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadUserInfo() {
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

    func displayIdentity() {
        if let client = SwissPassClientManager.shared.loginClient {
            guard let user = client.user else {
                let alert = UIAlertController(title: "ID Token Error", message: "Missing claims in the ID Token.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)

                return
            }
            var array: Array<[String : AnyObject]> = Array()

            if let firstName = user.firstName {
                array.append(["Vorname": firstName as AnyObject])
            }
            if let lastName = user.lastName {
                array.append(["Name": lastName as AnyObject])
            }
            if let loginEmail = user.loginEmail {
                array.append(["Email": loginEmail as AnyObject])
            }
            if let birthdate = user.birthdate {
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                let formattedString = formatter.string(for: birthdate)
                
                array.append(["Geburtsdatum": formattedString as AnyObject])
            }
            array.append(["SPIdpUID": user.userId as AnyObject])

            self.dataSource = array
            self.tableView.reloadData()
        }
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
