//
//  RespondModel.swift
//  LightSW
//
//  Created by Mojy on 2018/7/19.
//  Copyright © 2018年 Mojy. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name
// swiftlint:disable colon

import Foundation

class ResultModel {
    
    var command: UInt8 = 0
    var length: UInt8 = 0
    var index: UInt8 = 0
    var address: [UInt8]?
    var data: [UInt8]?
    
    var contentData : Data?
    
    class func convert(bytes: [UInt8]) -> ResultModel? {
        
        if bytes.count == 0 { return nil }
        
//        var bytes:[UInt8] = [UInt8](data)
        if bytes[0] != 0xaa || bytes.count < 8 {
            return nil
        }
        
        let command = bytes[1]
        let length = bytes[2] // 数据头，尾，命令行，长度，校验位，每个1个字节,数据的字节
        let index = bytes[3] //流水号
        let address = [bytes[4], bytes[5]] //地址
        
        if bytes[2] + 3 > bytes.count {
            //数据未接收完成
            return nil
        }
        
        var respondData = [UInt8]()
        let contentLent = Int(length - 5)
        if contentLent > 0 {
            for i in 0..<contentLent where i < bytes.count {
                respondData.append(bytes[i+6])
            }
        }
        
        let model = ResultModel()
        model.command = command
        model.length = length
        model.index = index
        model.address = address
        model.data = respondData        
        model.contentData = Data(bytes[0..<Int(bytes[2] + 3)])
        
        return model
        
    }
}

class RespondModel {
    
    var type: UInt8 = 0
    var len: UInt8 = 0
    var value: [UInt8] = [UInt8]()
    
    init(data: Data) {
        parseChrData(data: data)
    }
    
    init(bytes: [UInt8]) {
        parseChrData(data: Data(bytes))
    }
    
    func parseChrData(data: Data) {
        
        if data.count > 2 {
            let bytes:[UInt8] = [UInt8](data)
            var pos = 0
            type =  bytes[pos]; pos += 1
            len = bytes[pos]; pos += 1
            
            value.removeAll()
            for i in 0..<len {
                value.append(bytes[Int(i+2)])
            }
        }
    }
    
    class func parse(data: Data) -> [RespondModel] {
        
        var items = [RespondModel]()
        var tempData: Data? = data
        
        repeat {
            let model = RespondModel.init(data: tempData!)
            if model.len > 0 {
                let dataLen: Int = Int(2 + model.len)
                items.append(model)
                
                if dataLen < tempData!.count {
                    tempData = tempData?.subdata(in: dataLen..<(tempData?.count)!)
                } else {
                    tempData = nil
                }
            } else {
                tempData = nil
            }
        } while tempData != nil
        
        return items
    }
}

class SubRespondData {
    
    var type: UInt8 = 0
    var index: UInt8 = 0
    var len: UInt8 = 0
    var value: [UInt8] = [UInt8]()
    
    init(data: Data) {
        parseChrData(data: data)
    }
    
    init(bytes: [UInt8]) {
        parseChrData(data: Data(bytes))
    }
    
    func parseChrData(data: Data) {
        
        if data.count > 2 {
            let bytes:[UInt8] = [UInt8](data)
            var pos = 0
            type =  bytes[pos]; pos += 1
            index =  bytes[pos]; pos += 1
            len = bytes[pos]; pos += 1
            
            value.removeAll()
            for i in 0..<len {
                value.append(bytes[Int(i+2)])
            }
        }
    }
}
