//
//  ViewController.swift
//  Weather
//
//  Created by Yeliz Keçeci on 14.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectCountryPickerView: UIPickerView! {
        didSet{
            selectCountryPickerView.delegate = self
            selectCountryPickerView.dataSource = self
        }
    }
    
    var countries: [Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let localData = self.readLocalFile(forName: "country") {
            self.getCountries(jsonData: localData)
        }
        self.view.addSubview(selectCountryPickerView)
        selectCountryPickerView.center = self.view.center
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
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
        
        for i in (0..<countries.count) {
            print("Name: \(String(describing: countries[i].name))")
            print("Code: \(String(describing: countries[i].code))")
            print("======================")
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
    
    
}
