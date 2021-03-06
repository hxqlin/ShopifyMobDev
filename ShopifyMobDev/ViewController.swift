//
//  ViewController.swift
//  ShopifyMobDev
//
//  Created by Hannah Lin on 2017-09-10.
//  Copyright © 2017 Hannah Lin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var totalBatzSpentField: UITextField!
    @IBOutlet weak var totalBronzeBagsSoldField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the JSON
        if let path = Bundle.main.path(forResource: "shopify", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = JSON(data: data)
                if json != JSON.null {
                    // calculate the total Napoleon Batz spent
                    let batzTotal = totalBatzSpent(json: json)
                    
                    // change the corresponding text field to display the result
                    totalBatzSpentField.text = String(batzTotal)
                    
                    // calculate the total number of Awesome Bronze Bags sold
                    let numBags = totalBronzeBagsSold(json: json)
                    
                    // change the corresponding text field to display the result
                    totalBronzeBagsSoldField.text = String(numBags)
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    func totalBatzSpent(json: JSON) -> Double {
        var total = 0.0
        for (_, order) in json["orders"] {
            let customerName = order["billing_address"]["name"].stringValue
            if (customerName == "Napoleon Batz") {
                let itemsPrice = order["total_line_items_price"].doubleValue
                total += itemsPrice
            }
        }
        return total
    }
    
    func totalBronzeBagsSold(json: JSON) -> Int {
        var bagCount = 0;
        for (_, order) in json["orders"] {
            let items = order["line_items"]
            for (_, item) in items {
                if (item["title"].stringValue == "Awesome Bronze Bag") {
                    let quantity = item["fulfillable_quantity"].intValue
                    bagCount += quantity
                }
            }
        }
        return bagCount
    }


}

