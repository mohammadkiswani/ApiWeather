
import UIKit

final class ViewController: UIViewController {
    
    // MARK: Outlet
    
    @IBOutlet private weak var countryPiker: UIPickerView!
    @IBOutlet private weak var yourTemp: UILabel!
    @IBOutlet private weak var minTempLable: UILabel!
    @IBOutlet private weak var maxTempLable: UILabel!
    @IBOutlet private weak var humidityLable: UILabel!
    
    //test
    
    // MARK: Properties
    
    private let netWorkingClient = NetWorkingClient()
    private var names = [String]()
    private var temp = [String]()
    private var temp_min = [String]()
    private var temp_max = [String]()
    private var humidity = [String]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountryPicker()
        getJson()
    }

    // MARK: Setup
    
    private func setupCountryPicker() {
        countryPiker.dataSource = self
        countryPiker.delegate = self
    }
    
    // MARK: API
    
    private func getJson() {
        guard let urTolExcute =  URL(string: "https://samples.openweathermap.org/data/2.5/find?lat=55.5&lon=37.5&cnt=10&appid=b6907d289e10d714a6e88b30761fae22")else {
            return
        }
        netWorkingClient.execute(_url: urTolExcute){ (array , error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            else if let array = array {
                var x = 9.0
                for dictionary in array {
                    self.names.append((dictionary["name"] as? String)!)
                    let mainDic = dictionary["main"] as! [String: Any]
                    let temp:Double = mainDic["temp"]! as! Double
                    self.temp.append(String(format:"%.2f", (temp) / x))
                    print(mainDic["temp"]!)
                    x += 1.5
                    
                    self.temp_min.append(String(format:"%.2f", (temp) / (x + 2)))
                    
                    self.temp_max.append(String(format:"%.2f", (temp) / (x - 1) ))
                    
                    self.humidity.append(String(mainDic["humidity"] as! Int))
                }
                self.countryPiker.reloadAllComponents()
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction private func Show(_ sender: Any) {
        let index = countryPiker.selectedRow(inComponent: 0)
        yourTemp.text = temp[index]
        minTempLable.text = temp_min[index]
        minTempLable.textColor = UIColor.black
        maxTempLable.text = temp_max[index]
        maxTempLable.textColor = UIColor.black
        humidityLable.text = humidity[index]
        humidityLable.textColor = UIColor.black
    }
}

// MARK:-  Extension

extension ViewController: UIPickerViewDataSource , UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return names.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return names[row]
    }
}
