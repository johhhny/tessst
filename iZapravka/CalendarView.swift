//
//  File.swift
//  iZapravka
//
//  Created by user on 13.02.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import Foundation

var arrayVsemArrays = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]]
var arrayDatesGasStation = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]]

//var arrayVsemArrays1 = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]]
//var arrayDatesGasStation1 = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]]
//var isTrue = true

var numbersCount = 11
var size1 = CGFloat()
var size2 = CGFloat()

class CalendarView : UIViewController {
    
    @IBOutlet weak var parentCollectionView: UICollectionView!
    @IBOutlet weak var labelForYear: UILabel!
    //var arrayVsemArrays = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]]
    var arrayOfMonths: [String]? = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    //var numbersCount = 0
    
    //---Функция для рассчета дня недели
    func calculateWeekDay(day: Int, month: Int, year: Int) -> (Int) {
        let a = (14 - month) / 12
        let y = year - a
        let m = month + 12 * a - 2
        return ((7000 + (day + y + y / 4 - y / 100 + y / 400 + (31 * m) / 12)) % 7)
    }
        
    override func viewWillAppear(_ animated: Bool) {
  
        //---Штуки для работы с текущим годом
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        //---Получаем даты заправок
        var arrayOfDates = [String]()
        let form = DateFormatter()
        for gasStaion in requestGasStation.arrayForGasStations {
            form.dateFormat = "yyyy"
            var dateForm = form.string(from: gasStaion.value(forKey: "date") as! Date)
            if Int(dateForm)! == year {
                form.dateFormat = "dd.MM.yyyy"
                dateForm = form.string(from: gasStaion.value(forKey: "date") as! Date)
                arrayOfDates.append(dateForm)
            }
            //let dateForm = form.string(from: gasStaion.value(forKey: "date") as! Date)
            //arrayOfDates.append(dateForm)
        }
        //print(arrayOfDates)
        arrayDatesGasStation = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]]
        for date in arrayOfDates {
            let array = date.components(separatedBy: ".")
            for i in 1...12 {
                if Int(array[1]) == i {
                    arrayDatesGasStation[i-1].append(String(Int(array[0])!))
                }
            }
        }
        
        //print(arrayForCalendar.arrayBig.)
        
        //---Строим даты текущего года
        //---Показываем на экране какой текущий год
        labelForYear.text = "\(year)"
        
        var firstDateOfMonth = [String]()
        var lastDateOfMonth = [String]()
        
        //---Формируем массивы с начальными и конечными датами
        for i in 1...12 {
            firstDateOfMonth.append("01." + String(i) + "." + String(year))
            switch i {
            case 1, 3, 5, 7, 8, 10, 12:
                lastDateOfMonth.append("31." + String(i) + "." + String(year))
            case 4, 6, 9, 11:
                lastDateOfMonth.append("30." + String(i) + "." + String(year))
            case 2:
                if let date = form.date(from: "29.02." + String(year)) {
                    let formDateToStr = form.string(from: date)
                    lastDateOfMonth.append(formDateToStr)
                } else {
                    lastDateOfMonth.append("28.02." + String(year))
                }
            default:
                break
            }
        }
        //print(lastDateOfMonth)
        
        //---Строим даты
        //---Считаем дни недель и номер последней недели
        var newArray = [["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""]]
        arrayVsemArrays = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]]
        numbersCount = 11
        for i in 0...11 {
            var weekDayBegin = 0
            var weekDayEnd = 0
            var weekNumber = 0
            
            let arrayBegin = firstDateOfMonth[i].components(separatedBy: ".")
            let arrayEnd = lastDateOfMonth[i].components(separatedBy: ".")
            
            weekDayBegin = calculateWeekDay(day: Int(arrayBegin[0])!, month: Int(arrayBegin[1])!, year: Int(arrayBegin[2])!)
            if weekDayBegin == 0 {
                weekDayBegin = 7
            }
            
            weekDayEnd = calculateWeekDay(day: Int(arrayEnd[0])!, month: Int(arrayEnd[1])!, year: Int(arrayEnd[2])!)
            if weekDayEnd == 0 {
                weekDayEnd = 7
            }
            
            weekNumber = Int(ceil((Double(weekDayBegin) + Double((arrayEnd[0]))! - 1.5) / 7))
            //---Строим даты в массив
            
            var summa = 1
            for i in 1...6 {
                for j in 1...7 {
                    if (i == 1) && (j < weekDayBegin) {
                        
                        newArray[i-1][j-1].append(" ")
                    } else {
                        if i < weekNumber {
                            newArray[i-1][j-1].append("\(summa)")
                            summa += 1
                        }
                    }
                    if i == weekNumber && j <= weekDayEnd {
                        newArray[i-1][j-1].append("\(summa)")
                        summa += 1
                    }
                    if i > weekNumber {
                        newArray[i-1][j-1].append(" ")
                    }
                    if i == weekNumber && j > weekDayEnd {
                        newArray[i-1][j-1].append(" ")
                    }
                }
            }
            //print(newArray)
            
            for n in 1...6 {
                for m in 1...7 {
                    arrayVsemArrays[i].append(newArray[n - 1][m - 1])
                }
            }
            arrayVsemArrays[i].removeFirst()
            
            newArray = [["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""]]
        }
 
        
        
        //parentCollectionView.reloadData()
        //print(form.string(from: form.date(from: firstDateOfMonth[2])!))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayVsemArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "parentCell", for: indexPath) as! ParentCollectionViewCell
        
        cell.labelForMonth.text = arrayOfMonths?[indexPath.row]
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width / 3) - 1  , height: (self.view.frame.height / 5.25) - 1 ) //105)
    }
}

class ParentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelForMonth: UILabel!
    @IBOutlet weak var childCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        childCollectionView.delegate = self
        childCollectionView.dataSource = self
    }
}

extension ParentCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if arrayVsemArrays[numbersCount][indexPath.row] != " " {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "childCell", for: indexPath) as! ChildCollectionViewCell
            let labeel = UILabel()
            //print(arrayDatesGasStation)
            if labeel.superview == nil {
                let frame = CGRect(x: 0, y: 0, width: size1, height: size2)
                cell.contentView.frame = frame
                labeel.frame = cell.contentView.frame
                cell.contentView.addSubview(labeel)
                labeel.font = UIFont.systemFont(ofSize: 10)
                labeel.textAlignment = .center
                labeel.layer.masksToBounds = true
                labeel.layer.cornerRadius = 8.5
            }

            for date in arrayDatesGasStation[numbersCount] {
                if arrayVsemArrays[numbersCount][indexPath.row] == date {
                    labeel.textColor = UIColor.white
                    labeel.backgroundColor = UIColor.red
                    labeel.text = arrayVsemArrays[numbersCount][indexPath.row]
                } else {
                    labeel.text = arrayVsemArrays[numbersCount][indexPath.row]
                }
            }
            
            if indexPath.row == 41 {
                numbersCount -= 1
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "childCell", for: indexPath)
            if indexPath.row == 41 {
                numbersCount -= 1
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        size1 = ((childCollectionView.frame.width) / 7) - 1
        size2 = ((childCollectionView.frame.height) / 6) - 1
        return CGSize(width: (childCollectionView.frame.width) / 7 - 1, height: (childCollectionView.frame.height) / 6 - 1 )//14)//(self.view.frame.height / 4))
    }
}

class ChildCollectionViewCell: UICollectionViewCell {
    
    //var labeel: UILabel! = UILabel()
    
    /*override func prepareForReuse() {
        labeel.removeFromSuperview()
        labeel.text = nil
        labeel = nil
    }*/
    
}
