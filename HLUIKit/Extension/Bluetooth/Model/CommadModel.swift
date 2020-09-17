//
//  CommadModel.swift
//  LightSW
//
//  Created by mojingyu on 2018/4/1.
//  Copyright © 2018年 Mojy. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name
// swiftlint:disable colon
// swiftlint:disable large_tuple

import Foundation
import SwiftDate

typealias CommandWithFilter = (Command, UInt8)

enum Command {
    
//    case reset
//    case verify
//    case checkPassword(String)
//    case firmware(data: Data, index: Int, address: Int)   //固件
//    case authorize
//    case queryPairedDevice
//    case powerStatus
//    case themeInfo
//    case scheduleInfo
//    case power(isOn: Bool)
//    case scheduleModel
//    case changeScene(sceneID: Int)
//    case addTheme(themeID: UInt8, channelID: UInt8, colors: [UInt8], xValue: UInt8)
//    case editTheme(themeID: UInt8, channelID: UInt8, colors: [UInt8], xValue: UInt8)
//    case editThemeName(UInt8, String)
//    case deleteTheme(UInt8)
//
//    case simpleScheduleTime(scheduleTime:ScheduleTime, index: Int, week: UInt8, ida: UInt8)
//    case customScheduleTime(scheduleTime:ScheduleTime, index: Int, date: Date, ida: UInt8)
//    case updateController
//    case managerChannels(oldID: UInt8, newID: UInt8)
//    case unpairDevice
//    case pairDevice
//    case pairSwitches
//    case pairBulbs
//    case stopPairing
//    case prepareSwitchUpdate
//
//    case photocell(isDefault: Bool)
}

extension Command {

    //命令
    var data: NSData {
        
        let byteArray: [UInt8] = []
//        switch self {
//        case .reset:
//            byteArray = [0xaa, 0x65, 0x06, 0x01, 0x00, 0x00, 0x00, 0x62, 0x55]
//        case .verify:
//            byteArray = [0x83]
//        case .checkPassword(let password):
//            byteArray = Array(password.utf8)
//
//        case .firmware(data: let data, index: let index, address: let address):
//            byteArray = firmwareData(data: data, index: index, address: address)
//
//        case .authorize:
//            byteArray = authorizeData()
//
//        case .queryPairedDevice:
//            byteArray = format(command: 0x01, data: nil, index: sendIndex)
//
//        case .powerStatus:
//            byteArray = format(command: 0x02, data: nil, index: sendIndex)
//
//        case .themeInfo:
//            let data = Data.init(bytes: [0xff])
//            byteArray = format(command: 0x10, data: data, index: sendIndex, address: 0x00)
//
//        case .scheduleInfo:
//            let data = Data.init(bytes: [0xff])
//            byteArray = format(command: 0x30, data : data, index: sendIndex)
//
//        case .power(isOn: let isOn):
//            byteArray = powerData(isOn: isOn)
//        case .scheduleModel:
//            let data = Data.init(bytes: [0x00, 0x01, 0x02])
//            byteArray = format(command: 0x03, data: data, index: sendIndex, address: 0x00)
//        case .changeScene(let sceneID):
//            let data = Data.init(bytes: [UInt8(sceneID)])
//            byteArray = format(command: 0x14, data: data, index: sendIndex, address: 0x00)
//
//        case .addTheme(let themeID, let channelID, let colors, let xValue):
//            let data = Data.init(bytes: [themeID, 0x03, 0x05, channelID, colors[0], colors[1], colors[2], xValue])
//            byteArray = format(command: 0x11, data: data, index: sendIndex, address: 0x00)
//
//        case .editTheme(themeID: let themeID, channelID: let channelID, colors: let colors, xValue: let xValue):
//            let data = Data.init(bytes: [themeID, 0x03, 0x05, channelID, colors[0], colors[1], colors[2], xValue])
//            byteArray = format(command: 0x12, data: data, index: sendIndex, address: 0x00)
//
//        case .editThemeName(let themeID, let name):
//
//            let buf: [UInt8] = Array(name.utf8)
//            let len = buf.count
//
//            var bytes = [UInt8]()
//            bytes.append(themeID)
//            bytes.append(0x04)
//            bytes.append(UInt8(len))
//            for i in 0..<len {
//                bytes.append(buf[i])
//            }
//
//            let data = Data.init(bytes: bytes)
//            byteArray = format(command: 0x12, data: data, index: sendIndex, address: 0x00)
//        case .deleteTheme(let themeID):
//            let data = Data.init(bytes: [themeID])
//            byteArray = format(command: 0x13, data: data, index: sendIndex, address: 0x00)
//
//        case .simpleScheduleTime(let scheduleTime, let index, let week, let ida):
//
//            let isOn = ida == 0xff ? false : true
//            let ids: UInt8 = UInt8(index)
//            let ida: UInt8 = ida
//            let photoCell: UInt8 = scheduleTime.usePhotoCell ? 0x01 : 0x00
//
//            var bytes = [UInt8]()
//            bytes.append(ids)
//            bytes.append(ida)
//            bytes.append(0x00)
//            bytes.append(0x01)
//            bytes.append(isOn ? photoCell : 0x00)
//
//            bytes.append(0x03)
//            bytes.append(0x03)
//
//            bytes.append(UInt8(week))  //weak
//
//            if let date = isOn ? scheduleTime.timeOn?.systemDate : scheduleTime.timeOff?.systemDate {
//
//                print("===== schedule time: \(date.weekday) \(date.hour) \(date.minute)")
//
//                bytes.append(UInt8(date.hour))  //hour
//                bytes.append(UInt8(date.minute))  //min
//            }
//            else {
//                bytes.append(0x00)  //hour
//                bytes.append(0x00)  //min
//            }
//
//            let data = Data.init(bytes: bytes)
//            byteArray = format(command: 0x31, data: data, index: sendIndex, address: 0x00)
//
//        case .customScheduleTime(let scheduleTime, let index, let date, let ida):
//
//            let isOn = ida == 0xff ? false : true
//            let ids: UInt8 = UInt8(index)
//            let ida: UInt8 = ida
//            let photoCell: UInt8 = scheduleTime.usePhotoCell ? 0x01 : 0x00
//
//            var bytes = [UInt8]()
//            bytes.append(ids)
//            bytes.append(ida)
//            bytes.append(0x00)
//            bytes.append(0x01)
//            bytes.append(isOn ? photoCell : 0x00)
//
//            bytes.append(0x02)
//            bytes.append(0x06)
//
//            if let timeDate: Date = (isOn ? scheduleTime.timeOn?.systemDate : scheduleTime.timeOff?.systemDate) {
//                print("===== schedule time: \(date.year) \(date.month) \(date.day) \(timeDate.hour) \(timeDate.minute)")
//
//                bytes.append(UInt8((date.year >> 8) & 0xff))  //yaer
//                bytes.append(UInt8(date.year & 0xff))  //yaer
//                bytes.append(UInt8(date.month))  //month
//                bytes.append(UInt8(date.day))  //day
//                bytes.append(UInt8(timeDate.hour))  //hour
//                bytes.append(UInt8(timeDate.minute))  //min
//            }
//            else {
//                bytes.append(UInt8((date.year >> 8) & 0xff))  //yaer
//                bytes.append(UInt8(date.year & 0xff))  //yaer
//                bytes.append(UInt8(date.month))  //month
//                bytes.append(UInt8(date.day))  //day
//                bytes.append(0x00)  //hour
//                bytes.append(0x00)  //min
//            }
//
//            let data = Data.init(bytes: bytes)
//            byteArray = format(command: 0x31, data: data, index: sendIndex, address: 0x00)
//
//        case .updateController:
//            byteArray = format(command: 0x34, data: nil, index: sendIndex, address: 0x00)
//        case .managerChannels(let oldID, let newID):
//            let data = Data.init(bytes: [oldID, newID])
//            byteArray = format(command: 0x06, data: data, index: sendIndex, address: 0x00)
//        case .unpairDevice:

//            byteArray = [0xaa, 0x04, 0x06, 0x12, 0x00, 0x00, 0x01, 0x11, 0x55]
//        case .pairDevice:
//            byteArray = format(command: 0x05, data: Data.init(bytes: [0x01]), index: sendIndex, address: 0x00)
//        case .stopPairing:

//            byteArray = [0xaa, 0x05, 0x06, 0x0c, 0x00, 0x00, 0x00, 0x0f, 0x55]
//        case .prepareSwitchUpdate:
//            byteArray = format(command: 0x07, data: Data.init(bytes: [0x00]), index: sendIndex, address: 0x00)
//        case .pairSwitches:
//            byteArray = [0xaa, 0x05, 0x06, 0x0c, 0x00, 0x00, 0x01, 0x0e, 0x55]
//        case .pairBulbs:
//            byteArray = [0xaa, 0x05, 0x06, 0x0c, 0x00, 0x00, 0x02, 0x0d, 0x55]
//        case .photocell(let isDefault):
//
//            if isDefault == true {
//                byteArray = [0xaa, 0x08, 0x06, 0x02, 0x00, 0x00, 0x01, 0x0d, 0x55]
//            }
//            else {
//                byteArray = [0xaa, 0x08, 0x06, 0x03, 0x00, 0x00, 0x00, 0x0d, 0x55]
//            }
//        }
        
        let data = Data(byteArray)
        return data as NSData
    }
    
    //解析
    static func parse(data: Data) -> (command: UInt8, length: UInt8, data: Data?, isSuccess: Bool) {
        
        let bytes:[UInt8] = [UInt8](data)
        let command: UInt8 = 0
        let length: UInt8 = 0
        
//        if bytes[0] != 0xaa || data.count < 8 {
//            return (0xff, 0, nil, false)
//        }
//
//        let command = bytes[1]
//        let length = bytes[2] - 5 // 数据头，尾，命令行，长度，校验位，每个1个字节,数据的字节
//
//        if bytes[2] + 3 > bytes.count {
//            //数据未接收完成
//            return (command, length, data, false)
//        }

        var respondData = [UInt8]()
        for i in 0..<length where i < (bytes.count - 6) {
            respondData.append(bytes[Int(i+6)])
        }
        
        return (command, length, Data(respondData), true)
    }
    
    //解析特征值
//    static func parseCharacteristic(data: Data) -> (chr: UInt8, len: UInt8, value: [UInt8]) {
//        
//        var bytes:[UInt8] = [UInt8](data)
//        var pos = 0
//        let type =  bytes[pos]; pos += 1
//        let len = bytes[pos]; pos += 1
//        
//        var value = [UInt8]()
//        for i in 0..<len {
//            value.append(bytes[Int(i+2)])
//        }
//        
//        return (type, len, value)
//    }
    
    //打包
    func format(command:Int, data:Data?, index: Int, address: Int = 0x00) -> [UInt8] {
        var byteArray: [UInt8] = [UInt8]()
        byteArray.append(0xaa)  //帧头
        byteArray.append(UInt8(command))  //指令 62为发送
        
        let dataLen = data == nil ? 0 : (data?.count)!
        byteArray.append(UInt8(dataLen + 5)) //数据长度:“流水号+地址+数据+校验+帧尾”的字节数;
        let curIndex = (index > 255) ? (index % 255) : index
        byteArray.append(UInt8(curIndex)) //流水号
        
        //地址
        byteArray.append(0x00)
        byteArray.append(UInt8(address))
        
        //数据
        for i in 0..<dataLen {
            byteArray.append((data?[i])!)
        }
        
        //校验: 将“指令+数据长度+流水号+地址+数据”进行异或校验;
        var verifyCode: UInt8 = 0
        for i in 1..<byteArray.count {
            verifyCode ^= byteArray[i]
        }
        byteArray.append(verifyCode)
        
        //帧尾
        byteArray.append(0x55)
        
        return byteArray
    }
 
}
