/*
 * Copyright (C) Schweizerische Bundesbahnen SBB, 2017.
 */

import UIKit
import SwissPassClient

let cellIdentifier = "buttonCell"

class MasterTableViewController: UITableViewController {
    
    var accessToken: String = ""
    var canActivateSwissPass = false    // this value is set to true or false by the method getAccountStatusSwissPassMobile()
    
    public enum Section: Int {
        case data = 0
        case operations
        case swisspass
        case swisspassmobile
        
        enum DataRow: Int {
            case accessToken
            case userInfo
            case user

            var string: String {
                get {
                    switch self {
                    case .accessToken: return "Access Token"
                    case .userInfo: return "User Data"
                    case .user: return "User Identity"
                    }
                }
            }
        }

        enum OperationsRow: Int {
            case refresh
            case authenticateDeviceOwner
            
            var string: String {
                get {
                    switch self {
                    case .refresh: return "Renew token"
                    case .authenticateDeviceOwner: return "Confirmation (Device Owner)"
                    }
                }
            }
        }

        enum SwissPassRow: Int {
            case accountManagement
            case loginDataManagement
            case cardLinkingManagement
            
            var string: String {
                get {
                    switch self {
                    case .accountManagement: return "User profile"
                    case .loginDataManagement: return "Login-Data"
                    case .cardLinkingManagement: return "Connect the SwissPass-Card"
                    }
                }
            }
        }
        
        enum SwissPassMobileRow: Int {
            case deactivateSwissPassMobile
            case showSwissPassMobile
            
            var string: String {
                get {
                    switch self {
                    case .deactivateSwissPassMobile: return "Deactivate SwissPassMobile"
                    case .showSwissPassMobile: return "Open SwissPassMobile"
                    }
                }
            }
        }

        var string: String {
            get {
                switch self {
                case .data: return "Data"
                case .operations: return "Operations"
                case .swisspass: return "SwissPass"
                case .swisspassmobile: return "SwissPassMobile"
                }
            }
        }
        
        func rows() -> Int {
            switch self {
            case Section.data: return 3
            case Section.operations: return 2
            case Section.swisspass: return 3
            case Section.swisspassmobile: return 2
            }
        }
        
        static func count() -> Int {
            return 4
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // based on the account status the UI knows if the user is allowed to activate a swisspass mobile or not
        // if the user is not allowed, the button "Show SwissPassMobile" will be disabled (and has the gray color)
        if !hasSwissPassMobile() {
            getAccountStatusSwissPassMobile()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getAccountStatusSwissPassMobile()
    }
    
    internal func presentAlert(withMessage message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - SwissPass Login

    @objc func logout() {
        if let client = SwissPassClientManager.shared.loginClient {
            client.requestLogout(completionHandler: { (result) in
                self.performSegue(withIdentifier: "LogoutSegue", sender: self)
            })
        }
    }
    
    internal func requestAuthenticationUsingDeviceOwnerAuthentication() {
        if let client = SwissPassClientManager.shared.loginClient {
            client.requestAuthentication(self, usingAuthenticationMethod: .deviceOwnerAuthentication, userInfoText: "Confirmation", completionHandler: { (result) in
                switch result {
                case .failure(let authenticationError):
                    self.presentAlert(withMessage: authenticationError.localizedDescription, title: "Confirmation failed")
                case .success():
                    self.presentAlert(withMessage: "The authorization was successful!", title: "Authentication successful")
                }
            })
        }
    }
    
    internal func refreshToken() {
        if let client = SwissPassClientManager.shared.loginClient {
            self.tableView.isUserInteractionEnabled = false;
            client.requestToken(completionHandler: { (result) in
                self.tableView.isUserInteractionEnabled = true;
                
                switch result {
                case .failure(let refreshError):
                    self.presentAlert(withMessage: refreshError.localizedDescription, title: "Refresh failed")
                case .success(let token):
                    self.accessToken = token
                }
                self.tableView.reloadData()
            })
        }
    }
    
    internal func openSwissPassPage(_ page:Page) {
        if let client = SwissPassClientManager.shared.loginClient {
            client.openSwissPass(self, withPage: page, completionHandler: { (result) in
                switch result {
                case .failure(let error):
                    switch error {
                    case .webSessionClosed(let detail):
                        self.presentAlert(withMessage: "Browser closed \(detail.debugDescription)", title: "Info!")
                    default:
                        self.presentAlert(withMessage: error.localizedDescription, title: "Error!")
                    }
                default:
                    break
                }
                
            })
        }
    }
    
    // MARK: SwissPassMobile
    
    internal func activateSwissPassMobile() {
        if let client = SwissPassClientManager.shared.mobileClient {
            client.requestSwissPassMobileActivation(self, completionHandler: { (result) in
                switch result {
                case .failure(let error):
                    self.presentAlert(withMessage: error.localizedDescription, title: "Error during the activation")
                case .success():
                    self.tableView.reloadData()
                    self.showSwissPassMobile()  // push the viewController with the SwissPassMobile
                }
            })
        }
    }
    
    internal func deactivateSwissPassMobile() {
        if let client = SwissPassClientManager.shared.mobileClient {
            if client.isSwissPassMobileAvailable() {
                client.requestSwissPassMobileDeactivation(completionHandler: { (result) in
                    switch result {
                    case .failure(let error):
                        self.presentAlert(withMessage: error.localizedDescription, title: "Error during the deactivation")
                    case .success():
                        self.tableView.reloadData()
                        self.presentAlert(withMessage: "The SwissPassMobile has been deactivated", title: "Success")
                    }
                })
            } else {
                presentAlert(withMessage: "You have no SwissPass activated", title: "You can't deactivate the SwissPassMobile because there is no SwissPassMobile activated")
            }
        }
    }
    
    internal func showSwissPassMobile() {
        if let client = SwissPassClientManager.shared.mobileClient {
            if client.isSwissPassMobileAvailable() {
                let card = SwissPassMobileViewController(initWithClient: client)
                self.navigationController?.present(card, animated: true)
            } else {
                self.presentAlert(withMessage: "You have no SwissPassMobile activated", title: "No SwissPass")
            }
        }
    }
    
    internal func getAccountStatusSwissPassMobile() {
        if let client = SwissPassClientManager.shared.mobileClient {
            // In this method we ask the status of the user's account.
            // Based on the status that we get back, we know if the user is allwed to
            // activate the swisspassmobile or not, so we can prepare the UI accordingly
            client.requestSwissPassMobileAccountStatus { (result: Result<SwissPassMobileAccountStatus, SwissPassMobileError>) in
                switch result {
                case .failure(let error):
                    self.canActivateSwissPass = false
                    print(error.localizedDescription)
                case .success(let status):
                    switch status {
                    case .accountBlocked:
                        self.canActivateSwissPass = false
                    case .activationPossible:
                        self.canActivateSwissPass = true
                    case .noSwissPassCard:
                        self.canActivateSwissPass = false
                    case .tooManyActivations:
                        self.canActivateSwissPass = true
                    @unknown default:
                        fatalError()
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.string
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        return section.rows()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .data:
            let dataRows = Section.DataRow(rawValue: indexPath.row)!
            switch dataRows {
            case .accessToken:
                cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
                cell.detailTextLabel?.text = self.accessToken
            case .userInfo:
                cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath)
            case .user:
                cell = tableView.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath)
            }
            cell.textLabel?.text = dataRows.string
        case .operations:
            let operationsRows = Section.OperationsRow(rawValue: indexPath.row)!
            return getEnabledCell(forIndexPath: indexPath, text: operationsRows.string)
        case .swisspass:
            let swissPassRows = Section.SwissPassRow(rawValue: indexPath.row)!
            return getEnabledCell(forIndexPath: indexPath, text: swissPassRows.string)
        case .swisspassmobile:
            let swissPassRows = Section.SwissPassMobileRow(rawValue: indexPath.row)!
            switch swissPassRows {
                // this button is only enabled when there is already a SwissPassMobile registered
                case .deactivateSwissPassMobile:
                    if hasSwissPassMobile() {
                        return getEnabledCell(forIndexPath: indexPath, text: swissPassRows.string)
                    } else {
                        return getDisabledCell(forIndexPath: indexPath, text: swissPassRows.string)
                    }
                case .showSwissPassMobile:
                    // if the status of the user is not ok for activation, and there is not
                    // yet a SwissPassMobile, we disable the button "Show SwissPassMobile"
                    if !hasSwissPassMobile() && !canActivateSwissPass {
                        return getDisabledCell(forIndexPath: indexPath, text: swissPassRows.string)
                    } else {
                        return getEnabledCell(forIndexPath: indexPath, text: swissPassRows.string)
                }
            }
        }
        
        return cell
    }
    
    private func getDisabledCell(forIndexPath indexPath: IndexPath, text: String)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        cell.textLabel?.text = text
        cell.textLabel?.textColor = .gray
        return cell
    }
    
    private func getEnabledCell(forIndexPath indexPath: IndexPath, text: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor(red: 0.0, green: 0.478431, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = Section(rawValue: indexPath.section)!
        
        if section == .swisspassmobile {
            let swissPassMobileRows = Section.SwissPassMobileRow(rawValue: indexPath.row)!
            switch swissPassMobileRows {
            // the button deactivate must be selectable only if there is a swisspassmobile
            case .deactivateSwissPassMobile:
                return hasSwissPassMobile() ? indexPath : nil
            // we disable the button if the user is not allowed to activate the SwissPassMobile and has not yet one
            case .showSwissPassMobile:
                return !hasSwissPassMobile() && !canActivateSwissPass ? nil : indexPath
            }
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .data:
            if indexPath.row == Section.DataRow.userInfo.rawValue {
                self.performSegue(withIdentifier: "ShowUserInfoSegue", sender: "UserInfo")
            }
            else if indexPath.row == Section.DataRow.user.rawValue {
                self.performSegue(withIdentifier: "ShowUserInfoSegue", sender: "User")
            }
        case .operations:
            let operationsRows = Section.OperationsRow(rawValue: indexPath.row)!
            switch operationsRows {
            case .authenticateDeviceOwner:
                self.requestAuthenticationUsingDeviceOwnerAuthentication()
            case .refresh:
                self.refreshToken()
            }
        case .swisspass:
            let swissPassRows = Section.SwissPassRow(rawValue: indexPath.row)!
            switch swissPassRows {
            case .accountManagement:
                self.openSwissPassPage(.accountManagement)
            case .loginDataManagement:
                self.openSwissPassPage(.loginDataManagement)
            case .cardLinkingManagement:
                self.openSwissPassPage(.cardLinkingManagement)
            }
        case .swisspassmobile:
            let swissPassMobileRows = Section.SwissPassMobileRow(rawValue: indexPath.row)!
            switch swissPassMobileRows {
            case .deactivateSwissPassMobile:
                self.deactivateSwissPassMobile()
            case .showSwissPassMobile:
                if hasSwissPassMobile() {   // if there SwissPassMobile is already activated
                    self.showSwissPassMobile()    // we can show it directly
                } else {
                    self.activateSwissPassMobile()    // otherwise we show the view for the activation
                }
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func hasSwissPassMobile() -> Bool {
        if let client = SwissPassClientManager.shared.mobileClient {
            return client.isSwissPassMobileAvailable()
        }
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserInfoSegue" {
            if let destination = segue.destination as? DetailTableViewController {
                switch sender as? String {
                case "UserInfo":
                    destination.mode = .userInfo
                case "User":
                    destination.mode = .user
                default:
                    fatalError()
                }
            }
        }
    }

}

