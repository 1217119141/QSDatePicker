//
//  UIViewExtension.swift
//  date
//
//  Created by 业通宝 on 2020/5/7.
//  Copyright © 2020 业通宝. All rights reserved.
//

import UIKit

public extension UIView{
    
    /// 起点x坐标
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x = newValue
            frame = tmpFrame
        }
    }
    
    /// 起点y坐标
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y = newValue
            frame = tmpFrame
        }
    }
    
    /// 中心点x坐标
    var centerX : CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tmpCenter : CGPoint = center
            tmpCenter.x = newValue
            center = tmpCenter
        }
    }
    
    /// 中心点y坐标
    var centerY : CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tmpCenter : CGPoint = center
            tmpCenter.y = newValue
            center = tmpCenter
        }
    }
    
    /// 宽度
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width = newValue
            frame = tmpFrame
        }
    }
    
    /// 高度
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height = newValue
            frame = tmpFrame
        }
    }
    
    /// 顶部
    var top : CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y = newValue
            frame = tmpFrame
        }
    }
    
    /// 底部
    var bottom : CGFloat {
        get {
            return frame.size.height + frame.origin.y
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y = newValue - frame.size.height
            frame = tmpFrame
        }
    }
    
    /// 左边
    var left : CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x = newValue
            frame = tmpFrame
        }
    }
    
    /// 右边
    var right : CGFloat {
        get {
            return frame.size.width + frame.origin.x
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x = newValue - frame.size.width
            frame = tmpFrame
        }
    }
    
    /// size
    var size: CGSize{
        get {
            return frame.size
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.size = newValue
            frame = tmpFrame
        }
    }
    
    /// 右边
    var origin: CGPoint{
        get {
            return frame.origin
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin = newValue
            frame = tmpFrame
        }
    }
    
    // MARK: - layer
    func rounded(_ cornerRadius: CGFloat) {
        rounded(cornerRadius, width: 0, color: nil)
    }

    func border(_ borderWidth: CGFloat, color borderColor: UIColor?) {
        rounded(0, width: borderWidth, color: borderColor)
    }

    func rounded(_ cornerRadius: CGFloat, width borderWidth: CGFloat, color borderColor: UIColor?) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }

    func round(_ cornerRadius: CGFloat, rectCorners rectCorner: UIRectCorner) {

        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    func shadow(_ shadowColor: UIColor?, opacity: CGFloat, radius: CGFloat, offset: CGSize) {
        //给Cell设置阴影效果
        layer.masksToBounds = false
        if let CGColor = shadowColor?.cgColor {
            layer.shadowColor = CGColor
        }
        layer.shadowOpacity = Float(opacity)
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
    
    // MARK: - base
    var viewController: UIViewController? {
        var nextResponder = self.next
        while nextResponder != nil {
            if (nextResponder is UIViewController) {
                let vc = nextResponder as? UIViewController
                return vc
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    class func getLabelHeight(byWidth width: CGFloat, title: String?, font: UIFont?) -> CGFloat {

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.text = title
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        let height = label.frame.size.height
        return height
    }
}
