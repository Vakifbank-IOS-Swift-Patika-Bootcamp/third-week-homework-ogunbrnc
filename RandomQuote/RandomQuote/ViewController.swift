//
//  ViewController.swift
//  RandomQuote
//
//  Created by Ogün Birinci on 19.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteContentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Client.getRandomQuote { quote, error in
            guard let quote = quote else { return }
            self.quoteContentLabel.text = quote.en ?? ""
        }
    }

   
    @IBAction func generateRandomQuote(_ sender: Any) {
        Client.getRandomQuote { quote, error in
            guard let quote = quote else { return }
            self.quoteContentLabel.text = quote.en ?? ""
        }
    }
    
    
}

