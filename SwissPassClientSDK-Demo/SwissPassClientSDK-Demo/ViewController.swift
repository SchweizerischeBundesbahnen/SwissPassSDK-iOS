/*
 * Copyright (C) Schweizerische Bundesbahnen SBB, 2017.
 */

import UIKit
import SwissPassClient

class ViewController: UIViewController {
    
    @IBOutlet weak var environments: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let client = SwissPassClientManager.shared.loginClient {
            switch client.environment {
            case .development:
                self.environments.selectedSegmentIndex = 0
            case .integration:
                self.environments.selectedSegmentIndex = 1
            case .production:
                self.environments.selectedSegmentIndex = 2
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let client = SwissPassClientManager.shared.loginClient {
            client.requestToken(forceRefresh: false, completionHandler: { (result) in
                switch result {
                case .failure(let error):
                    switch error {
                    case SwissPassLoginError.invalidGrant:
                        break
                    case SwissPassLoginError.invalidToken:
                        break
                    default:
                        self.performSegue(withIdentifier: "ShowTableViewControllerSegue", sender: nil)
                    }
                    
                case .success(let token):
                    self.performSegue(withIdentifier: "ShowTableViewControllerSegue", sender: token)
                }
            })
        }
    }

    @IBAction func environmentDidChange(_ sender: Any) {
        if self.environments.isEqual(sender) {
            switch self.environments.selectedSegmentIndex {
            case 0:
                SwissPassClientManager.shared.environment = .development
            case 1:
                SwissPassClientManager.shared.environment = .integration
            case 2:
                SwissPassClientManager.shared.environment = .production
            default:
                fatalError()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
        if let client = SwissPassClientManager.shared.loginClient {
            client.requestLogin(self, withScope: SwissPassClientManager.shared.scope, completionHandler: { (result) in
                switch result {
                case .failure(let loginError):
                    let alert = UIAlertController(title: "Achtung", message: loginError.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                case .success(let token):
                    // proceed to the next view controller
                    self.performSegue(withIdentifier: "ShowTableViewControllerSegue", sender: token)
                }
            })
        }
        
    }

    @IBAction func register(_ sender: Any) {
        if let client = SwissPassClientManager.shared.loginClient {
            client.requestRegistration(self, completionHandler: { (result) in
                switch result {
                case .failure(let registrationError):
                    let alert = UIAlertController(title: "Fehler", message: "Es konnte kein Konto erstellt werden.\nDetail: \(registrationError.localizedDescription)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                case .success( _):
                    let alert = UIAlertController(title: "Erfolg", message: "Das Konto wurde erstellt. Bitte loggen Sie sich nun mit ihrem Benutzer beim System an.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // MARK: - Segue

    @IBAction func unwindToRootViewController(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTableViewControllerSegue" {
            if let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? MasterTableViewController {
                if let tokenString = sender as? String, tokenString.isEmpty == false {
                    destination.accessToken = sender as! String
                }
            }
        }
    }
}

