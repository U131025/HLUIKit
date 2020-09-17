//
//  String+Format.swift
//  Exchange
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019 mac. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

//数据类型转换
extension String {
    public var doubleValue: Double {
        return Double(priceValue) ?? 0.00
    }

    public var floatValue: CGFloat {
        return CGFloat(self.doubleValue)
    }

    /// 不能含有小数点或逗号
    public var intValue: Int {
        return Int(priceValue) ?? 0
    }

    public var priceValue: String {
        return self.pregReplace(pattern: ",", with: "")
    }

    public var decimalValue: Decimal {
        return Decimal(string: self) ?? Decimal(0)
    }
}

//格式化
extension String {

    //使用正则表达式替换
//    常用的一些正则表达式：
//    非中文：[^\\u4E00-\\u9FA5]
//    非英文：[^A-Za-z]
//    非数字：[^0-9]
//    非中文或英文：[^A-Za-z\\u4E00-\\u9FA5]
//    非英文或数字：[^A-Za-z0-9]
//    非英文或数字或下划线：[^A-Za-z0-9_]
    public func pregReplace(pattern: String,
                            with: String,
                            options: NSRegularExpression.Options = []) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return ""
        }

        return regex.stringByReplacingMatches(in: self,
                                              options: [],
                                              range: NSRange(location: 0, length: self.count),
                                              withTemplate: with)
    }

    public func pregReplace(pattern: String,
                            with: String,
                            maxLen: Int) -> String {

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return ""
        }
        let text = regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSRange(location: 0, length: self.count),
                                              withTemplate: with)

        //整数位长度校验
        if text.count > maxLen {
            return text.substring(to: maxLen - 1)
        }
        return text
    }

    // 价格字符串格式化
    public func formatPriceString(_ maxLen: Int = 16, decimalLen: Int = 2) -> String? {

        let input = self.pregReplace(pattern: "[^0-9.]", with: "")

        let values = input.components(separatedBy: ".")
        if values.count > 2 {

            if decimalLen == 0 { return values[0] }

            let string = values[0] + "." + values[1]
            return string
        }

        if values.count > 0 {

            //整数位长度校验
            if values[0].count > maxLen {
                return input.substring(to: maxLen - 1)
            }

            //小数点后两位
            if values.count > 1 && decimalLen == 0 {
                return values[0]
            } else if values.count > 1 && values[1].count > decimalLen {
                let string = values[0] + "." + values[1].substring(to: decimalLen - 1)
                return string
            }
        }

        return input
    }

    // 币数量字符串格式化
    public func formatCoinNumberString(decimalLen: Int, integralLen: Int = 9) -> String? {

        /// Fix: 调整价格输入限制
        let input = self.pregReplace(pattern: "[^0-9.]", with: "")

        let index = input.findFirst(".")
        if index > 0 {

            /// 整数位
            var integra = input.substring(to: index - 1)
            integra = "\(integra.intValue)"

            /// 长度限制
            if integra.count > integralLen {
                integra = integra.substring(to: integralLen - 1)
            }

            /// 小数位
            var decimal = input.substring(from: index + 1)
            decimal = decimal.trimmingCharacters(in: CharacterSet.init(charactersIn: "."))

            if Int(decimal) != nil {

                if decimal.count > decimalLen {
                    decimal = decimal.substring(to: decimalLen - 1)
                }

                return integra + "." + decimal
            }

            return integra + "."
        } else {
            if input == "." { return "0." }

            if input.count > integralLen {
                return input.substring(to: integralLen - 1)
            }
            return input.count > 0 ? "\(input.intValue)" : input
        }
        /// Fix End
    }
    //非四舍五入保留2位小数
    public var reserveTwoDecimalsString: String {
        var value: Double = Double(self) ?? 0.0
        value = (value * 100).rounded()
        return String(format: "%.2lf", value/100)
    }
    // 保留指定位小数，位数不足补0
    public func format(decimalSize: Int) -> String {
        let list = self.components(separatedBy: ".")
        var decimalStr = ""
        var integalStr = ""
        /// 处理整数位为0的负数
        let lessThanZero = self.doubleValue < 0

        if list.count < 2 {
            for _ in 0..<decimalSize {
                decimalStr += "0"
            }
            if list[0].isEmpty {
                integalStr = "0"
            } else {
                integalStr = list[0]
            }
        } else {
            integalStr = "\(Int(list[0]) ?? 0)"
            if lessThanZero, integalStr.intValue >= 0 {
                integalStr = "-" + integalStr
            }
            let count = list[1].count
            if count < decimalSize {
                decimalStr = list[1]

                for _ in count..<decimalSize {
                    decimalStr += "0"
                }
            } else {
                decimalStr = list[1].substring(to: decimalSize-1)
            }
        }
        if decimalSize == 0 { return integalStr }
        return integalStr + "." + decimalStr
    }

    /// 固定5位字符长度
    /// 不足补零，超过则去除小数位(12345 -> 12.3k)
    /// - Parameter len: 长度
    /// - Returns:
    public func fixedFiveCharacterLength() -> String {
        guard !self.isEmpty else { return "0.000" }
        /// 先将字符分成小数和整数两部分，如果整数部分大于1000，则处理整数位即可
        let list = self.components(separatedBy: ".")
        let integer = list[0].intValue
        if integer >= 1000 {
            var res = Decimal(integer) / 1000.0
            var unit = "K"
            // 整数位超过百万时
            if Int(integer) >= 1000000 {
                res = Decimal(integer) / 1000000.0
                unit = "M"
            }
            let value = res.description.format(decimalSize: 2)
            if value.positionOf(sub: ".") == 3 {
                return value.substring(to: 2) + unit
            } else {
                return value.substring(to: 3) + unit
            }
        } else {
            if list.count == 1 {
                let decimal = 5-list[0].count-1
                if decimal > 0 {
                    var zeroStr = ""
                    for _ in 1...decimal {
                        zeroStr.append("0")
                    }
                    return list[0] + "." + zeroStr
                }
            } else if list.count == 2 {
                // 先补充到5位小数，再进行截取
                let res = self.format(decimalSize: 5)
                return "\(res)".substring(to: 5-1)
            }
        }
        return self
    }

}

extension CGFloat {
    public func format(_ minDigits: Int = 0, _ style: NumberFormatter.Style = NumberFormatter.Style.currency) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.positivePrefix = ""   //去掉前缀
        formatter.minimumFractionDigits = minDigits // 最小小数位
        let string = formatter.string(from: NSNumber(value: Float(self)))
        return string
    }
    /// 保留指定位小数
    public func roundTo(places: Int) -> String {
        let divisor = pow(10.0, Double(places))
        let result = (Double(self) * divisor).rounded() / divisor
        if places == 0 {
            return "\(Int(self))"
        }
        return "\(result)"
    }
    public func format(_ showUnit: Bool) -> String {
        return String(format: showUnit ? "¥%@" : "%@", format() ?? "")
    }
}
