//
//  QSDateSelection.swift
//  date
//
//  Created by 业通宝 on 2020/5/23.
//  Copyright © 2020 业通宝. All rights reserved.
//

import UIKit

@objc public class QSDateSelection: NSObject {
    
    var pickerView:QSDatePickerView!
    /// 底部背景颜色(默认白色)
    var bottomBackGroundColor:UIColor = UIColor.white{
        didSet{
            pickerView.bottomBackGroundColor = bottomBackGroundColor
        }
    }
    /// 按钮背景颜色(默认白色)
    var btnBackGroundColor:UIColor = UIColor.white{
        didSet{
            pickerView.btnBackGroundColor = btnBackGroundColor
        }
    }
    /// 按钮字体颜色(默认黑色)
    var btnTitleColor:UIColor = UIColor.black{
        didSet{
            pickerView.btnTitleColor = btnTitleColor
        }
    }
    /// 按钮字体大小
    var btnTitleFont:UIFont = UIFont.systemFont(ofSize: 16){
        didSet{
            pickerView.btnTitleFont = btnTitleFont
        }
    }
    /// 年-月-日-时-分 文字颜色(默认黑色)
    var dateLabelColor:UIColor = UIColor.black{
        didSet{
            pickerView.dateLabelColor = dateLabelColor
        }
    }
    /// 限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
    var maxLimitDate = Date.date(datestr: "2099-12-31 23:59", WithFormat: "yyyy-MM-dd HH:mm"){
        didSet{
            pickerView.maxLimitDate = maxLimitDate
        }
    }
    /// 限制最小时间（默认1900） datePicker小于最小日期则滚动回最小限制日期
    var minLimitDate = Date.date(datestr: "1900-01-01 00:00", WithFormat: "yyyy-MM-dd HH:mm"){
        didSet{
            pickerView.minLimitDate = minLimitDate
        }
    }
    
    
    init(dateStyle style: QSDateStyle, scrollTo date: Date? = nil, completeBlock: @escaping (Date) -> Void) {
        if let date = date{
            pickerView = QSDatePickerView(dateStyle: style, scrollTo: date) { selectDate in
                completeBlock(selectDate)
            }
            return
        }
        pickerView = QSDatePickerView(dateStyle: style) { selectDate in
            completeBlock(selectDate)
        }
    }
    func show(){
        pickerView.show()
    }
    func dissMiss(){
        pickerView.dismiss()
    }
}
