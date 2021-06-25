//
//  AppImageHelper.swift
//  图片压缩处理
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

extension UIImage {    
    public func compress(maxSize: Int = 1024 * 2) -> Data? {
        return HLImageHelper.compressImageSize(image: self, maxSize: maxSize)
    }
}

public class HLImageHelper: NSObject {

    //图片压缩 1000kb以下的图片控制在100kb-200kb之间
    public class func compressImageSize(image: UIImage, maxSize: Int = 1024 * 3) -> Data? {
        
        guard var imageData = image.jpegData(compressionQuality: 1) else { return nil }
        var sizeOriginKB = imageData.count/1024 as Int  //获取图片大小KB
        print("==== 压缩前大小: \(sizeOriginKB) KB")
        
        // 压缩系数
        var resizeRate = 0.9
        let maxSize = maxSize   /// 3M
        
        if sizeOriginKB <= maxSize {
            return imageData
        }
        
        // 接口最大接受大小
        while (sizeOriginKB > maxSize) && (resizeRate > 0.01) {
            resizeRate -= 0.2
            imageData = image.jpegData(compressionQuality: CGFloat(resizeRate))!
            sizeOriginKB = Int(CGFloat(imageData.count) / 1024.0)
        }
        
        let zipSize = imageData.count/1024 as Int
        print("==== 压缩后大小: \(zipSize) KB")
        return imageData
    }
    
    public class func resizeImage(originalImg: UIImage) -> UIImage {
        
        //prepare constants
        let width = originalImg.size.width
        let height = originalImg.size.height
        let scale = width/height
        
        var sizeChange = CGSize()
        
        if width <= 1280 && height <= 1280 { //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return originalImg
        }else if width > 1280 || height > 1280 {//b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale >= 0.5 && scale <= 1 {
                
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if width > 1280 && height > 1280 {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                
                if scale > 2 {//高的值比较小
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if scale < 0.5{//宽的值比较小
                    
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }
            }else {//d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return originalImg
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        
        //draw resized image on Context
        originalImg.draw(in: CGRect.init(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
        
        //create UIImage
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImg!
        
    }
}
