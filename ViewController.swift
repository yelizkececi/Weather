//
//  ViewController.swift
//  Weather
//
//  Created by Yeliz Keçeci on 14.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var selectCountryPickerView: UIPickerView = UIPickerView()
    @IBOutlet weak var countriesTextField: UITextField!
    
    var countries: [Country] = []
    var selectedCountry: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCountryPickerView.delegate = self
        selectCountryPickerView.dataSource = self
        if let localData = self.readLocalFile(forName: "country") {
            self.getCountries(jsonData: localData)
        }
        countriesTextField.placeholder = "Select Country"
        countriesTextField.textAlignment = .center
        countriesTextField.inputView = selectCountryPickerView
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func getCountries(jsonData: Data) -> [Country]? {
        
        do {
            countries = try JSONDecoder().decode([Country].self, from: jsonData)
            
        } catch(let error) {
            print("decode error \(error)")
            return nil
        }
        return countries
    }
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[selectCountryPickerView.selectedRow(inComponent: 0)].name!
        countriesTextField.text = selectedCountry
    }
    
}
