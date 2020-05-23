//
//  QSDatePickerView.swift
//  date
//
//  Created by 业通宝 on 2020/5/7.
//  Copyright © 2020 业通宝. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

let isIphoneX_XS = ScreenWidth == 375 && ScreenHeight == 812 ? true : false
let isIphoneXR_XSMax = ScreenWidth == 414 && ScreenHeight == 896 ? true : false
let isFullScreen = isIphoneX_XS || isIphoneXR_XSMax
let TabbarSafeBottomMargin: CGFloat = isFullScreen ? 34 : 0

typealias DoneBlock = (_ date:Date) -> ()

public enum QSDateStyle {
    case DateStyleShowYearMonthDayHourMinute,//年月日时分
    DateStyleShowMonthDayHourMinute,//月日时分
    DateStyleShowYearMonthDay,//年月日
    DateStyleShowYearMonth,//年月
    DateStyleShowMonthDay,//月日
    DateStyleShowHourMinute,//时分
    DateStyleShowYear,//年
    DateStyleShowMonth,//月
    DateStyleShowDayHourMinute//日时分
}

class QSDatePickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate {
    
    /// 底部背景颜色(默认白色)
    var bottomBackGroundColor:UIColor = UIColor.white{
        didSet{
            buttomView.backgroundColor = bottomBackGroundColor
        }
    }
    /// 按钮背景颜色(默认白色)
    var btnBackGroundColor:UIColor = UIColor.white{
        didSet{
            doneBtn.backgroundColor = btnBackGroundColor
            closeBtn.backgroundColor = btnBackGroundColor
        }
    }
    /// 按钮字体颜色(默认黑色)
    var btnTitleColor:UIColor = UIColor.black{
        didSet{
            doneBtn.setTitleColor(btnTitleColor, for: .normal)
            closeBtn.setTitleColor(btnTitleColor, for: .normal)
        }
    }
    /// 按钮字体大小
    var btnTitleFont:UIFont = UIFont.systemFont(ofSize: 16){
        didSet{
            doneBtn.titleLabel?.font = btnTitleFont
            closeBtn.titleLabel?.font = btnTitleFont
        }
    }
    /// 年-月-日-时-分 文字颜色(默认黑色)
    var dateLabelColor:UIColor = UIColor.black{
        didSet{
            for subView in buttomView.subviews {
                if let laebl = subView as? UILabel {
                    laebl.textColor = dateLabelColor
                }
            }
        }
    }
    
    /// 滚轮日期颜色(默认黑色)
    var datePickerColor:UIColor = UIColor.black
    
    private let topHeight:CGFloat = 44
    private let btnWidth:CGFloat = 60
    private let datePickerHeight:CGFloat = 200
    private let minYear = 1900
    private let maxYear = 2099
    
    /// 限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
    var maxLimitDate = Date.date(datestr: "2099-12-31 23:59", WithFormat: "yyyy-MM-dd HH:mm")
    
    /// 限制最小时间（默认1900） datePicker小于最小日期则滚动回最小限制日期
    var minLimitDate = Date.date(datestr: "1900-01-01 00:00", WithFormat: "yyyy-MM-dd HH:mm")
    
    private var doneBlock:DoneBlock!
    private var datePickerStyle:QSDateStyle = .DateStyleShowYearMonthDayHourMinute
    private var dateFormatter = "yyyy-MM-dd HH:mm"
    private var scrollToDate = Date()
    
    private var yearArray:[String] = []
    private var monthArray:[String] = []
    private var dayArray:[String] = []
    private var hourArray:[String] = []
    private var minuteArray:[String] = []
    //记录位置
    private var yearIndex:Int = 0
    private var monthIndex:Int = 0
    private var dayIndex:Int = 0
    private var hourIndex:Int = 0
    private var minuteIndex:Int = 0
    
    private var preRow:Int = 0
    
    private var startDate:Date = Date()
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(dateStyle style: QSDateStyle, completeBlock: @escaping (Date) -> Void) {
        super.init(frame: UIScreen.main.bounds)
        datePickerStyle = style
        switch style {
        case .DateStyleShowYearMonthDayHourMinute:
            dateFormatter = "yyyy-MM-dd HH:mm"
        case .DateStyleShowMonthDayHourMinute:
            dateFormatter = "yyyy-MM-dd HH:mm"
        case .DateStyleShowYearMonthDay:
            dateFormatter = "yyyy-MM-dd"
        case .DateStyleShowYearMonth:
            dateFormatter = "yyyy-MM"
        case .DateStyleShowMonthDay:
            dateFormatter = "yyyy-MM-dd"
        case .DateStyleShowHourMinute:
            dateFormatter = "HH:mm"
        case .DateStyleShowYear:
            dateFormatter = "yyyy"
        case .DateStyleShowMonth:
            dateFormatter = "MM"
        case .DateStyleShowDayHourMinute:
            dateFormatter = "dd HH:mm"
        }
        setupUI()
        defaultConfig()
        self.doneBlock = {(date:Date) in
            completeBlock(date)
        }
    }
    init(dateStyle style: QSDateStyle, scrollTo date: Date, completeBlock: @escaping (Date) -> Void) {
        super.init(frame: UIScreen.main.bounds)
        datePickerStyle = style
        scrollToDate = date
        switch style {
        case .DateStyleShowYearMonthDayHourMinute:
            dateFormatter = "yyyy-MM-dd HH:mm"
        case .DateStyleShowMonthDayHourMinute:
            dateFormatter = "yyyy-MM-dd HH:mm"
        case .DateStyleShowYearMonthDay:
            dateFormatter = "yyyy-MM-dd"
        case .DateStyleShowYearMonth:
            dateFormatter = "yyyy-MM"
        case .DateStyleShowMonthDay:
            dateFormatter = "yyyy-MM-dd"
        case .DateStyleShowHourMinute:
            dateFormatter = "HH:mm"
        case .DateStyleShowYear:
            dateFormatter = "yyyy"
        case .DateStyleShowMonth:
            dateFormatter = "MM"
        case .DateStyleShowDayHourMinute:
            dateFormatter = "dd HH:mm"
        }
        setupUI()
        defaultConfig()
        self.doneBlock = {(date:Date) in
            completeBlock(date)
        }
    }
    private lazy var buttomView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: ScreenHeight - datePickerHeight - topHeight - TabbarSafeBottomMargin, width: ScreenWidth, height: datePickerHeight + topHeight + TabbarSafeBottomMargin))
        view.backgroundColor = bottomBackGroundColor
        return view
    }()
    private lazy var doneBtn:UIButton = {
        let view = UIButton()
        view.backgroundColor = btnBackGroundColor
        view.setTitle("完成", for: .normal)
        view.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        view.setTitleColor(btnTitleColor, for: .normal)
        view.titleLabel?.font = btnTitleFont
        return view
    }()
    private lazy var closeBtn:UIButton = {
        let view = UIButton()
        view.backgroundColor = btnBackGroundColor
        view.setTitle("取消", for: .normal)
        view.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        view.setTitleColor(btnTitleColor, for: .normal)
        view.titleLabel?.font = btnTitleFont
        return view
    }()
    private lazy var datePicker:UIPickerView = {
        let view = UIPickerView()
        view.showsSelectionIndicator = true
        view.delegate = self
        view.dataSource = self
        return view
    }()
    @objc func doneAction(){
        startDate = scrollToDate.dateWithFormatter(formatter: dateFormatter)
        doneBlock(startDate)
        dismiss()
    }
    func setupUI(){
        self.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(buttomView)
        
        closeBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: topHeight)
        self.buttomView.addSubview(closeBtn)
        
        doneBtn.frame = CGRect(x: self.frame.size.width - btnWidth, y: 0, width: btnWidth, height: topHeight)
        self.buttomView.addSubview(doneBtn)
        
        datePicker.frame = CGRect(x: 0, y: 44, width: self.frame.size.width, height: datePickerHeight)
        self.buttomView.addSubview(datePicker)
    }
    func defaultConfig(){
        preRow = (scrollToDate.year - minYear) * 12 + scrollToDate.month - 1
        yearArray = setArray(yearArray)!
        monthArray = setArray(monthArray)!
        dayArray = setArray(dayArray)!
        hourArray = setArray(hourArray)!
        minuteArray = setArray(minuteArray)!
        for i in 0..<60 {
            let num = String(format: "%02d", i)
            if 0 < i && i <= 12 {
                monthArray.append(num)
            }
            if i < 24 {
                hourArray.append(num)
            }
            minuteArray.append(num)
        }
        for i in minYear...maxYear {
            let num = String(format: "%ld", Int(i))
            yearArray.append(num)
        }
        getNowDate(date: scrollToDate, animated: true)
    }
    
    func yearChange(row:Int){
        monthIndex = row % 12
        if row - preRow < 12 && row - preRow > 0 && Int(monthArray[monthIndex])! < Int(monthArray[preRow % 12])!{
            yearIndex += 1
        } else if preRow-row < 12 && preRow-row > 0 && Int(monthArray[monthIndex])! > Int(monthArray[preRow % 12])!{
            yearIndex -= 1
        }else{
            let interval = (row-preRow)/12
            yearIndex += interval
        }
        preRow = row
    }
    func addLabel(withName nameArr: [String]) {
        for subView in buttomView.subviews {
            if (subView is UILabel) {
                subView.removeFromSuperview()
            }
        }
        for i in 0..<(nameArr.count) {
            var a:CGFloat = 0
            if i == 0 && (datePickerStyle == .DateStyleShowYear || datePickerStyle == .DateStyleShowYearMonth || datePickerStyle == .DateStyleShowYearMonthDay || datePickerStyle == .DateStyleShowYearMonthDayHourMinute){
                a = datePicker.frame.size.width / CGFloat(nameArr.count * 2) + 20
            } else {
                a = datePicker.frame.size.width / CGFloat(nameArr.count * 2) + 10
            }
            let b = datePicker.frame.size.width / CGFloat(nameArr.count) * CGFloat(i)
            let labelX = a + b
            let label = UILabel(frame: CGRect(x: labelX, y: datePicker.frame.size.height / 2 - 7.5 + topHeight, width: 15, height: 15))
            label.text = nameArr[i]
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = dateLabelColor
            label.backgroundColor = UIColor.clear
            buttomView.addSubview(label)
        }
    }
    func setArray(_ mutableArray: [String]) -> [String]? {
        var mutableArray = mutableArray
        if mutableArray.count != 0 {
            mutableArray.removeAll()
        } else {
            mutableArray = []
        }
        return mutableArray
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch datePickerStyle {
        case .DateStyleShowYearMonthDayHourMinute:
            addLabel(withName: ["年", "月", "日", "时", "分"])
            return 5
        case .DateStyleShowMonthDayHourMinute:
            addLabel(withName: ["月", "日", "时", "分"])
            return 4
        case .DateStyleShowYearMonthDay:
            addLabel(withName: ["年", "月", "日"])
            return 3
        case .DateStyleShowYearMonth:
            addLabel(withName: ["年", "月"])
            return 2
        case .DateStyleShowMonthDay:
            addLabel(withName: ["月", "日"])
            return 2
        case .DateStyleShowHourMinute:
            addLabel(withName: ["时", "分"])
            return 2
        case .DateStyleShowYear:
            addLabel(withName: ["年"])
            return 1
        case .DateStyleShowMonth:
            addLabel(withName: ["月"])
            return 1
        case .DateStyleShowDayHourMinute:
            addLabel(withName: ["日", "时", "分"])
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberArr = getNumberOfRowsInComponent()
        return numberArr[component]
    }
    func getNumberOfRowsInComponent() -> [Int] {
        
        let yearNum = yearArray.count
        let monthNum = monthArray.count
        
        let dayNum = daysfromYear(Int(yearArray[yearIndex]) ?? 0, andMonth: Int(monthArray[monthIndex]) ?? 0)
        
        let dayNum2 = daysfromYear(Int(yearArray[yearIndex]) ?? 0, andMonth: 1) //确保可以选到31日
        
        let hourNum = hourArray.count
        let minuteNUm = minuteArray.count
        
        let timeInterval = maxYear - minYear
        
        switch datePickerStyle {
        case .DateStyleShowYearMonthDayHourMinute:
            return [yearNum, monthNum, dayNum, hourNum, minuteNUm]
        case .DateStyleShowMonthDayHourMinute:
            return [monthNum * timeInterval, dayNum, hourNum, minuteNUm]
        case .DateStyleShowYearMonthDay:
            return [yearNum, monthNum, dayNum]
        case .DateStyleShowYearMonth:
            return [yearNum, monthNum]
        case .DateStyleShowMonthDay:
            return [monthNum * timeInterval, dayNum, hourNum]
        case .DateStyleShowHourMinute:
            return [hourNum, minuteNUm]
        case .DateStyleShowYear:
            return [yearNum]
        case .DateStyleShowMonth:
            return [monthNum]
        case .DateStyleShowDayHourMinute:
            return [dayNum2, hourNum, minuteNUm]
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var customLabel = view as? UILabel
        if customLabel == nil {
            customLabel = UILabel()
            customLabel?.textAlignment = .center
            customLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        var title: String?
        
        switch datePickerStyle {
        case .DateStyleShowYearMonthDayHourMinute:
            if component == 0 {
                title = yearArray[row]
            }
            if component == 1 {
                title = monthArray[row]
            }
            if component == 2 {
                title = dayArray[row]
            }
            if component == 3 {
                title = hourArray[row]
            }
            if component == 4 {
                title = minuteArray[row]
            }
        case .DateStyleShowYearMonthDay:
            if component == 0 {
                title = yearArray[row]
            }
            if component == 1 {
                title = monthArray[row]
            }
            if component == 2 {
                title = dayArray[row]
            }
        case .DateStyleShowYearMonth:
            if component == 0 {
                title = yearArray[row]
            }
            if component == 1 {
                title = monthArray[row]
            }
        case .DateStyleShowMonthDayHourMinute:
            if component == 0 {
                title = monthArray[row % 12]
            }
            if component == 1 {
                title = dayArray[row]
            }
            if component == 2 {
                title = hourArray[row]
            }
            if component == 3 {
                title = minuteArray[row]
            }
        case .DateStyleShowMonthDay:
            if component == 0 {
                title = monthArray[row % 12]
            }
            if component == 1 {
                title = dayArray[row]
            }
        case .DateStyleShowHourMinute:
            if component == 0 {
                title = hourArray[row]
            }
            if component == 1 {
                title = minuteArray[row]
            }
        case .DateStyleShowYear:
            if component == 0 {
                title = yearArray[row]
            }
        case .DateStyleShowMonth:
            if component == 0 {
                title = monthArray[row]
            }
        case .DateStyleShowDayHourMinute:
            if component == 0 {
                title = dayArray[row]
            }
            if component == 1 {
                title = hourArray[row]
            }
            if component == 2 {
                title = minuteArray[row]
            }
        }
        customLabel?.text = title
        customLabel?.textColor = datePickerColor
        return customLabel!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch datePickerStyle {
        case .DateStyleShowYearMonthDayHourMinute:
            if component == 0 {
                yearIndex = row
            }
            if component == 1 {
                monthIndex = row;
            }
            if component == 2 {
                dayIndex = row
            }
            if component == 3 {
                hourIndex = row
            }
            if component == 4 {
                minuteIndex = row
            }
            if component == 0 || component == 1{
                let _ = daysfromYear(Int(yearArray[yearIndex])!, andMonth: Int(monthArray[monthIndex])!)
                if (dayArray.count-1 < dayIndex) {
                    dayIndex = dayArray.count - 1;
                }
            }
        case .DateStyleShowYearMonthDay:
            if component == 0 {
                yearIndex = row;
            }
            if component == 1 {
                monthIndex = row
            }
            if component == 2 {
                dayIndex = row
            }
            if (component == 0 || component == 1){
                let _ = daysfromYear(Int(yearArray[yearIndex])!, andMonth: Int(monthArray[monthIndex])!)
                if (dayArray.count-1 < dayIndex) {
                    dayIndex = dayArray.count - 1;
                }
            }
        case .DateStyleShowYearMonth:
            if component == 0 {
                yearIndex = row
            }
            if component == 1 {
                monthIndex = row
            }
        case .DateStyleShowMonthDayHourMinute:
            if component == 1 {
                dayIndex = row
            }
            if component == 2 {
                hourIndex = row
            }
            if component == 3 {
                minuteIndex = row
            }
            if component == 0 {
                yearChange(row: row)
                let _ = daysfromYear(Int(yearArray[yearIndex])!, andMonth: Int(monthArray[monthIndex])!)
                if (dayArray.count-1 < dayIndex) {
                    dayIndex = dayArray.count - 1;
                }
            }
            let _ = daysfromYear(Int(yearArray[yearIndex])!, andMonth: Int(monthArray[monthIndex])!)
        case .DateStyleShowMonthDay:
            if component == 1 {
                dayIndex = row
            }
            if component == 0 {
                yearChange(row: row)
                let _ = daysfromYear(Int(yearArray[yearIndex])!, andMonth: Int(monthArray[monthIndex])!)
                if (dayArray.count-1 < dayIndex) {
                    dayIndex = dayArray.count - 1;
                }
            }
            let _ = daysfromYear(Int(yearArray[yearIndex])!, andMonth: Int(monthArray[monthIndex])!)
        case .DateStyleShowHourMinute:
            if component == 0 {
                hourIndex = row
            }
            if component == 1 {
                minuteIndex = row
            }
        case .DateStyleShowYear:
            if component == 0 {
                yearIndex = row
            }
        case .DateStyleShowMonth:
            if component == 0 {
                monthIndex = row
            }
        case .DateStyleShowDayHourMinute:
            if component == 0 {
                dayIndex = row
            }
            if component == 1 {
                hourIndex = row
            }
            if component == 2 {
                minuteIndex = row
            }
        }
        pickerView.reloadAllComponents()
        var dateStr = "\(yearArray[yearIndex])-\(monthArray[monthIndex])-\(dayArray[dayIndex]) \(hourArray[hourIndex]):\(minuteArray[minuteIndex])"
        switch datePickerStyle {
        case .DateStyleShowYearMonthDay:
            dateStr = "\(yearArray[yearIndex])-\(monthArray[monthIndex])-\(dayArray[dayIndex])"
        case .DateStyleShowYearMonth:
            dateStr = "\(yearArray[yearIndex])-\(monthArray[monthIndex])"
        case .DateStyleShowMonthDay:
            dateStr = "\(yearArray[yearIndex])-\(monthArray[monthIndex])-\(dayArray[dayIndex])"
        case .DateStyleShowHourMinute:
            dateStr = "\(hourArray[hourIndex]):\(minuteArray[minuteIndex])"
        case .DateStyleShowYear:
            dateStr = "\(yearArray[yearIndex])"
        case .DateStyleShowMonth:
            dateStr = "\(monthArray[monthIndex])"
        case .DateStyleShowDayHourMinute:
            dateStr = "\(dayArray[dayIndex]) \(hourArray[hourIndex]):\(minuteArray[minuteIndex])"
        default:
            dateStr = "\(yearArray[yearIndex])-\(monthArray[monthIndex])-\(dayArray[dayIndex]) \(hourArray[hourIndex]):\(minuteArray[minuteIndex])"
        }
        scrollToDate = Date.date(datestr: dateStr, WithFormat: dateFormatter).dateWithFormatter(formatter: dateFormatter)
        if scrollToDate.compare(minLimitDate) == .orderedAscending{
            scrollToDate =  minLimitDate
            getNowDate(date: minLimitDate, animated: true)
        }else if scrollToDate.compare(maxLimitDate) == .orderedDescending{
            scrollToDate =  maxLimitDate
            getNowDate(date: maxLimitDate, animated: true)
        }
        startDate = scrollToDate
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: self.buttomView){
            return false
        }
        return true
    }
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
            self.layoutIfNeeded()
        }
    }
    @objc func dismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0)
            self.layoutIfNeeded()
        }) { finished in
            self.removeFromSuperview()
        }
    }
    //通过年月求每月天数
    func daysfromYear(_ year: Int, andMonth month: Int) -> Int {
        let num_year = year
        let num_month = month

        let isrunNian = num_year % 4 == 0 ? (num_year % 100 == 0 ? (num_year % 400 == 0 ? true : false) : true) : false
        switch num_month {
            case 1, 3, 5, 7, 8, 10, 12:
                setdayArray(31)
                return 31
            case 4, 6, 9, 11:
                setdayArray(30)
                return 30
            case 2:
                if isrunNian {
                    setdayArray(29)
                    return 29
                } else {
                    setdayArray(28)
                    return 28
                }
            default:
                break
        }
        return 0
    }
    //设置每月的天数数组
    func setdayArray(_ num: Int) {
        dayArray.removeAll()
        for i in 1...num {
            dayArray.append(String(format: "%02d", i))
        }
    }
    func getNowDate(date:Date, animated:Bool){

        let _ = daysfromYear(date.year, andMonth: date.month)
        yearIndex = date.year-minYear
        monthIndex = date.month-1
        dayIndex = date.day-1
        hourIndex = date.hour
        minuteIndex = date.minute
        preRow = (scrollToDate.year - minYear) * 12 + scrollToDate.month-1
        var indexArray:[Int] = []
        switch datePickerStyle {
        case .DateStyleShowYearMonthDayHourMinute:
            indexArray = [yearIndex,monthIndex,dayIndex,hourIndex,minuteIndex]
        case .DateStyleShowYearMonthDay:
            indexArray = [yearIndex,monthIndex,dayIndex]
        case .DateStyleShowYearMonth:
            indexArray = [yearIndex,monthIndex]
        case .DateStyleShowMonthDayHourMinute:
            indexArray = [monthIndex,dayIndex,hourIndex,minuteIndex]
        case .DateStyleShowMonthDay:
            indexArray = [monthIndex,dayIndex]
        case .DateStyleShowHourMinute:
            indexArray = [hourIndex,minuteIndex]
        case .DateStyleShowYear:
            indexArray = [yearIndex]
        case .DateStyleShowMonth:
            indexArray = [monthIndex]
        case .DateStyleShowDayHourMinute:
            indexArray = [dayIndex,hourIndex,minuteIndex]
        }
        datePicker.reloadAllComponents()
        for i in 0..<indexArray.count {
            if (datePickerStyle == .DateStyleShowMonthDayHourMinute || datePickerStyle == .DateStyleShowMonthDay) && i == 0 {
                let mIndex = indexArray[i] + 12 * (scrollToDate.year - minYear)
                datePicker.selectRow(mIndex, inComponent: i, animated: animated)
            } else {
                datePicker.selectRow(indexArray[i], inComponent: i, animated: animated)
            }
        }
    }
}

