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
    var cityName: String?
    
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCountryPickerView.delegate = self
        selectCountryPickerView.dataSource = self
        if let localData = self.readLocalFile(forName: "country-cities") {
            self.getCountries(jsonData: localData)
        }
        countriesTextField.inputView = selectCountryPickerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
    
    private func getCountries(jsonData: Data){
        print(jsonData)
        do {
            countries = try JSONDecoder().decode([Country].self, from: jsonData)
        } catch(let error) {
            print("decode error \(error)")
        }
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        sendCity(city: cityName)
    }
    
    func sendCity(city: String?) {
        if let city = city, !city.isEmpty {
            let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
            vc.city = city
            self.show(vc, sender: nil)
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Please,Select Country and City", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func selectCity(name: String?) {
        guard let name = name else { return }
        cityName = name
        countriesTextField.text = name
    }
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return countries.count
        } else{
            let selectedCountryIndex = selectCountryPickerView.selectedRow(inComponent: 0)
            return countries[selectedCountryIndex].cities!.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return countries[row].country
        case 1:
            let selectedCountryIndex = selectCountryPickerView.selectedRow(inComponent: 0)
            if selectedCountryIndex < countries.count {
                return countries[selectedCountryIndex].cities?[row] ?? ""
            } else {
                return ""
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountryIndex = selectCountryPickerView.selectedRow(inComponent: 0)
        let selectedCityIndex = selectCountryPickerView.selectedRow(inComponent: 1)
        switch component {
        case 0:
            selectCountryPickerView.reloadComponent(1)
            if (countries[selectedCountryIndex].cities?.count ?? 0) > 0 {
                selectCountryPickerView.selectRow(0, inComponent: 1, animated: true)
                selectCity(name: countries[selectedCountryIndex].cities?.first)
            }
        case 1:
           selectCity(name: countries[selectedCountryIndex].cities?[selectedCityIndex])
        default:
            break
        }
    }
}
