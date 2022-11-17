//
//  ViewController.swift
//  bitcoinTracker
//
//  Created by Kiran Kishore on 14/03/20.
//  Copyright © 2020 CDNS. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class TrackerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let baseURL = "https://api.nomics.com/v1/currencies/ticker?key=225789256632c86e14738d535298d9f4&ids=BTC&interval=1d,30d&convert="
    var finalURL = ""
    
    @IBOutlet weak var priceLbl: UILabel!
    
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        
        getBitcoinData(coinURL: finalURL)
        
        print(finalURL)
    }
    
    //MARK: Networking
    func getBitcoinData(coinURL: String){
        
        Alamofire.request(coinURL, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                print("Success, got bitcoin prices")
                let coinJSON : JSON = JSON(response.result.value!)
                print(coinJSON)
                self.updateCoinData(json: coinJSON)
                
            }else{
                print("Error \(String(describing: response.result.error))")
                print("Error\(String(describing: response.result.error))")
                self.priceLbl.text = "Connection Issues"
                
            }
        }
    }
    
    //MARK: JSON Parsing & UI Updation
    func updateCoinData(json: JSON ){
        if let coinResult = json[0]["price"].string{
            print(coinResult)
            
            
            
            priceLbl.text = coinResult
        }
        else{
            priceLbl.text = "Price unavailable"
        }
    }
    
}

