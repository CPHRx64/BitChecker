//
//  ViewController.swift
//  BitcoinTicker
//
//  Template provided by Angela Yu.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    //let price = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    // Load app
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        initApp()
    }

    /***************************************************************/
    //MARK: - UI configurations
    /***************************************************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    } // one column in picker
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    } // n rows in picker, n = length of currency array
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    } // content in each row of the picker
    
    
    /***************************************************************/
    //MARK: - Update UI
    /***************************************************************/
    func initApp() {
       finalURL = baseURL + currencyArray[0]
        getAndParse(url: finalURL)
    } // initalize app using the first currency in the array
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        getAndParse(url : finalURL)
    } // actionHandler
    
    func updateUI(json : JSON, key : String) {
        if let result = json[key].double {
            // success
            bitcoinPriceLabel.text = String(result)
        } else {
            bitcoinPriceLabel.text = "Not available"
        }   //fail - no data
    } // update price lable
    
    /***************************************************************/
    //MARK: - Networking & JSON Parsing
    /***************************************************************/
    func getAndParse(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    // success
                    self.updateUI(json : JSON(response.result.value!), key : "last")
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.updateUI(json : JSON(), key : "")
                }   // fail - no data
            }
    } // grab and JSONparse data from API
}

