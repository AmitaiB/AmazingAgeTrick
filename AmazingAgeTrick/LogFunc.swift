//
//  LogFunc.swift
//  AmazingAgeTrick
//
//  Created by Amitai Blickstein on 1/3/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import Foundation

public func EVLog<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
    let process = NSProcessInfo.processInfo()
    let threadId = "?"
    print("\(dateFormatter.stringFromDate(NSDate())) \(process.processName))[\(process.processIdentifier):\(threadId)] \(NSURL.init(string:filename)?.lastPathComponent)(\(line)) \(funcname):\r\t\(object)\n")
}
