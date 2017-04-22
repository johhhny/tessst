//
//  AddAndEditRowViewController.swift
//  iZapravka
//
//  Created by user on 29.01.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import CoreData

class AddAndEditRowViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var literTextField: UITextField!         //Текстовое поле для ввода кол-ва литров
    @IBOutlet weak var priceTextField: UITextField!         //Текстовое поле для ввода цены
    @IBOutlet weak var wayTextField: UITextField!           //Текстовое поле для ввода пробега
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var createAndSaveGasStation: UIButton!   //Кнопка для добавления и сохранения заправок
    @IBOutlet weak var lastWayLabel: UILabel!               //Метка для отображения последнего пробега
    
    var datePicker = UIDatePicker()
    var strForLiter = String()      //Строка для литров
    var strForWay = String()        //Строка для пробега
    var strForPrice = String()      //Строка для цены
    var indexRow = Int()            //Номер строки(заправки) в таблице
    var currentDate = Date()        //Текущая дата
    var buttonTitleSave = false     //Меняем/не меняем заголовок кнопки "добавить"/"сохранить"
    
    //Функция для делегирования, контекста, запроса и сортировки запроса
    func createDelegContextRequestAndSorted() throws -> [Any] {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GasStation")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try context.fetch(request)
    }
    
    //---Функция для созданий обычных сообщений
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated:  true)
    }
    //---
    //Убирать клавиатуру при нажатии на пустое поле
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //---
    //Убирать клавиатуру при нажатии на кнопку Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //---Действие при смене даты на пикере
    /*@IBAction func saveDate(_ sender: UIDatePicker) {
        //let formatter = DateFormatter()
        //formatter.dateStyle = .short
        currentDate = datePickerView.date
    }*/
    @IBAction func saveDate(_ sender: UITextField) {
        let form = DateFormatter()
        form.dateFormat = "dd.MM.yyyy"
        dateTextField.text = form.string(from: datePicker.date)
        currentDate = datePicker.date
    }
    
    //---Действие кнопки "Добавить"/"Сохранить"
    @IBAction func createObjInCoreData(_ sender: UIButton) {
        //---Проверка на пустые поля и на значения в них
        if (literTextField.text! == "" || priceTextField.text! == "" || wayTextField.text! == "") || (Double(priceTextField.text!) == nil || Double(literTextField.text!) == nil || Double(wayTextField.text!) == nil){
            createAlert(title: "Ошибка", message: "Заполните все поля числами")
        } else {
            //---Проверка заголовка кнопки на текст "Добавить"
            if createAndSaveGasStation.currentTitle == "Добавить" {
                var lastWay: Float = 0      //Обнуление последнего пробега
                //---Проверяем пустая таблица или нет
                if requestGasStation.arrayForGasStations.count != 0 {
                    //---Записываем последний пробег из 1 строки таблицы
                    lastWay = Float((requestGasStation.arrayForGasStations[0].value(forKey: "way") as! String))!
                    //---
                }
                //---
                //---Проверяем введеный пробег с текущим
                if lastWay >= Float(wayTextField.text!)! {
                    createAlert(title: "Ошибка", message: "Набранный вами пробег меньше текущего. Текущий пробег Вы можете посмотреть в 'статистике'")
                } else {
                    let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    let context = appDel.persistentContainer.viewContext
                    let newRow = NSEntityDescription.insertNewObject(forEntityName: "GasStation", into: context)
                    newRow.setValue(literTextField.text, forKey: "liter")
                    newRow.setValue(priceTextField.text, forKey: "price")
                    newRow.setValue(wayTextField.text, forKey: "way")
                    newRow.setValue(currentDate, forKey: "date")
                    do {
                        try context.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    literTextField.text = ""
                    priceTextField.text = ""
                    wayTextField.text = ""
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                    self.present(vc, animated: true, completion: nil)
                }
            } else if createAndSaveGasStation.currentTitle == "Сохранить" {
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                let context = appDel.persistentContainer.viewContext
                //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GasStation")
                //request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                do {
                    //let results = try context.fetch(request)
                    (requestGasStation.arrayForGasStations[indexRow] as AnyObject).setValue(literTextField.text, forKey: "liter")
                    (requestGasStation.arrayForGasStations[indexRow] as AnyObject).setValue(wayTextField.text, forKey: "way")
                    (requestGasStation.arrayForGasStations[indexRow] as AnyObject).setValue(priceTextField.text, forKey: "price")
                    (requestGasStation.arrayForGasStations[indexRow] as AnyObject).setValue(currentDate, forKey: "date")
                    try context.save()
                } catch {
                
                }
                buttonTitleSave = false
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        
        //textResultat.text = "Добавлено"
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //---закругление кнопки
        createAndSaveGasStation.layer.masksToBounds = true
        createAndSaveGasStation.layer.cornerRadius = 12
        
        literTextField.text = strForLiter
        priceTextField.text = strForPrice
        wayTextField.text = strForWay
        let date = Date()
        datePicker.maximumDate = date
        datePicker.datePickerMode = .date
        let form = DateFormatter()
        form.dateFormat = "dd.MM.yyyy"
        dateTextField.text = form.string(from: datePicker.date)
        dateTextField.inputView = datePicker
        if buttonTitleSave {
            datePicker.date = currentDate
            dateTextField.text = form.string(from: currentDate)
            createAndSaveGasStation.setTitle("Сохранить", for: .normal)
        } else {
            currentDate = datePicker.date
            createAndSaveGasStation.setTitle("Добавить", for: .normal)
        }
        if requestGasStation.arrayForGasStations.count != 0 {
            lastWayLabel.text = "Текущий пробег: \(requestGasStation.arrayForGasStations[0].value(forKey: "way")!)"
        } else {
            lastWayLabel.text = "Текущий пробег: 0"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
