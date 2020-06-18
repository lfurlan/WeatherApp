//
//  ViewController.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 13/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelButtonView: UILabel!
    @IBOutlet weak var buttonView: UIView!
    var weatherViewModel = WeatherViewModel()
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var indexDaysSelected = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
    }
    
    func setupView() {
        buttonView.layer.cornerRadius = 10
        self.tableView.register(UINib(nibName: "DayWeatherCell", bundle: nil), forCellReuseIdentifier: "DayWeatherCell")
        self.daysCollectionView.register(UINib(nibName: "DayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DayCollectionViewCell")
        
    }
    
    
    @IBAction func selectCityAction(_ sender: Any) {
        showPickerView()
    }
    
    func getWeather(){
        startIndicator()
        indexDaysSelected = 0
        weatherViewModel.fetchForecast(){success in
            self.stopIndicator()
            if success ?? false {
                self.daysCollectionView.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    
    func startIndicator(){
        activityIndicatorView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopIndicator(){
        activityIndicatorView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
    func showPickerView(){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Elija una ciudad", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default){ response in
            self.getWeather()
        })
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.weatherViewModel.groupedForecastsSorted.count != 0 {
            self.placeHolder.isHidden = true
            return self.weatherViewModel.groupedForecastsSorted[indexDaysSelected].value.count
        } else {
            self.placeHolder.isHidden = false
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
        
        let forecast = self.weatherViewModel.groupedForecastsSorted[indexDaysSelected].value[indexPath.row]
        cell.hourLabel.text = "\(forecast.hour!)"
        cell.descriptionLabel.text = "\(forecast.weatherDescription!)"
        cell.tempLabel.text = "\(Int(forecast.temp!))º"
        
        
        let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(forecast.icon!).png")
        let urlData = NSData(contentsOf: urlStr! as URL)
        if urlData != nil {
            cell.imageWeather.image = UIImage(data: urlData! as Data)
        }
        if indexPath.row == self.weatherViewModel.groupedForecastsSorted[indexDaysSelected].value.count - 1 {
            self.stopIndicator()
        }
        cell.layoutIfNeeded()
        return cell
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weatherViewModel.groupedForecastsSorted.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as! DayCollectionViewCell
        cell.dayNumberLabel.text = "\(self.weatherViewModel.groupedForecastsSorted[indexPath.row].key)"
        if indexPath.row == indexDaysSelected {
            cell.containerView.backgroundColor = AppColor.Blue
        } else {
            cell.containerView.backgroundColor = AppColor.LigthGray
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexDaysSelected = indexPath.row
        self.startIndicator()
        self.daysCollectionView.reloadData()
        self.tableView.reloadData()
    }
    
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weatherViewModel.cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weatherViewModel.cities[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let name = weatherViewModel.cities[row].name {
            labelButtonView.text = name
        }
        if let id = weatherViewModel.cities[row].id {
            self.weatherViewModel.weatherRequest?.id = "\(id)"
        }
    }
    
}

