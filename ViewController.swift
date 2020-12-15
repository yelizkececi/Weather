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
    var cityName: String? = nil
    
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCountryPickerView.delegate = self
        selectCountryPickerView.dataSource = self
        if let localData = self.readLocalFile(forName: "country-cities") {
            self.getCountries(jsonData: localData)
        }
        countriesTextField.placeholder = "Select Country and City"
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
        if component == 0 {
            return countries.count
        } else{
            let selectedCountry = selectCountryPickerView.selectedRow(inComponent: 0)
            return countries[selectedCountry].cities!.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return countries[row].country
        } else{
            let selectedCountry = selectCountryPickerView.selectedRow(inComponent: 0)
            return countries[selectedCountry].cities?[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCountryPickerView.reloadComponent(1)
        
        let selectCountry = selectCountryPickerView.selectedRow(inComponent: 0)
        let selectCity = selectCountryPickerView.selectedRow(inComponent: 1)
        //let country = countries[selectCountry].country
        cityName = countries[selectCountry].cities?[selectCity]
        
        countriesTextField.text = cityName
    }
    
}
