/*
 * Copyright (C) Schweizerische Bundesbahnen SBB, 2018.
 */

import Foundation
import SwissPassClient

public class SwissPassClientManager : Logging {
    
    static let shared = SwissPassClientManager()

    // SwissPassLogin
    let scope: Scope = Scope()
    var loginClient: SwissPassLoginClient?

    var environment: Environment {
        get {
            var env: Environment
            switch UserDefaults.standard.string(forKey: "SPLEnvironment") {
            case "test":
                env = .development
            case "inte":
                env = .integration
            case "prod":
                env = .production
            default:
                UserDefaults.standard.set("inte", forKey: "SPLEnvironment")
                env = .integration
            }
            return env
        }
        set {
            if environment != newValue {
                createClients(environment: newValue)
            }
            switch newValue {
            case .development:
                UserDefaults.standard.set("test", forKey: "SPLEnvironment")
            case .integration:
                UserDefaults.standard.set("inte", forKey: "SPLEnvironment")
            case .production:
                UserDefaults.standard.set("prod", forKey: "SPLEnvironment")
            }
        }
    }
    
    // SwissPassMobile
    var mobileClient: SwissPassMobileClient?

    private init() {
        createClients(environment: self.environment)
    }
    
    private func createClients(environment: Environment) {
        // Logger
        ClientFactory.logger = self

        // Login
        if let redirectURI = URL(string: "sidapp://oauth/callback") {
            let clientId:String!
            switch environment {
            case .development:
                clientId = "oauth_tester_test"
            case .integration:
                clientId = "oauth_tester_inte"
            case .production:
                clientId = "oauth_tester"
            }
            let settings = Settings(withClientID: clientId, provider: "oauth_t", redirectURI: redirectURI, environment: environment)
            
            self.loginClient = ClientFactory.createSwissPassLoginClient(withSettings: settings)
        }
        // SPM
        if let provider = self.loginClient {
            self.mobileClient = ClientFactory.createSwissPassMobileClient(withProvider: provider)
        }
    }

    // MARK: - Logging
    public func log(message: String, level: LogLevel) {
        print(message)
    }

}
