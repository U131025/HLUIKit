//
//  AppDelegate+Log.swift
//  Community
//
//  Created by mac on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import SwiftyBeaver

let logger = SwiftyBeaver.self

// MARK: 日志
extension AppDelegate {

    func initLogConfig() {
        let console = ConsoleDestination()
        console.format = "[$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l] $M"

        let file = FileDestination()
        _ = file.deleteLogFile()
        file.format = "[$DHH:mm:ss.SSS$d $L] $M"

        logger.addDestination(console)
        logger.addDestination(file)
    }

    func deleteFile(path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {}
    }

    func createFolder(path: String) {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Unable to create directory")
        }
    }
}
