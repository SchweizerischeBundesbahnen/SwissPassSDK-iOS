/*
 * Copyright (C) Schweizerische Bundesbahnen SBB, 2022.
 */

import UIKit
import SwissPassClient

class SwissPassMobileViewController: UIViewController, SwissPassMobileCardViewControllerDelegate {
    
    let client: SwissPassMobileClient
    
    weak var cardViewController: SwissPassMobileCardViewController?

    public init(initWithClient client: SwissPassMobileClient) {
        self.client = client
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .fill // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.spacing = 20.0

        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true

        if client.isSwissPassMobileAvailable() {
            let cardViewController = SwissPassMobileCardViewController(withClient: client)
            cardViewController.delegate = self
            addContentController(cardViewController, to: stackView)
            self.cardViewController = cardViewController
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Update shadow
        if let vc = cardViewController {
            vc.view.layer.shadowPath = UIBezierPath(rect: vc.view.bounds).cgPath
        }
    }

    private func addContentController(_ child: UIViewController, to stackView: UIStackView) {
        stackView.addArrangedSubview(child.view)
        
        addChild(child)
        child.didMove(toParent: self)
        
        // Draw a shadow around the card
        child.view.layer.shadowColor = UIColor.black.cgColor
        child.view.layer.shadowOpacity = 1.0
        child.view.layer.shadowOffset = .zero
        child.view.layer.shadowRadius = 10
    }

    func swissPassMobileCardViewControllerTapped(_ controller: SwissPassClient.SwissPassMobileCardViewController) {
        self.dismiss(animated: true)
    }
    
    func swissPassMobileCardViewControllerSwiped(_ controller: SwissPassClient.SwissPassMobileCardViewController, to page: SwissPassClient.SwissPassMobilePage) {
    }

}
