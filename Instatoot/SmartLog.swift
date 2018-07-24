//
//  SmartLog.swift
//  PocketStreamer
//
//  Created by Peter de Tagyos on 7/21/17.
//  Copyright © 2017 Peter de Tagyos. All rights reserved.
//


import Foundation

typealias L = SmartLog

public struct SmartLog {
    
    /**
        Write to the log unless FINAL is defined as a Swift Compiler Custom Flag.
    
        :param: value The object or string to print.
    
    */
    public static func debug<T>(_ value: T, file: String = #file, fn: String = #function, line: Int = #line) {
        #if !FINAL
//            let s = "[DEBUG]: \(file) - \(fn) - \(line): \(value)"
            let s = "[DEBUG]: \(value)"
            NSLog(s, [])
        #endif
    }
    
    /**
        Write to the log regardless of build mode. Always write to the log.

        :param: value The object or string to print.
    */
    public static func log<T>(_ value: T, file: String = #file, fn: String = #function, line: Int = #line) {
        let s = "[INFO]: \(file) - \(fn) - \(line): \(value)"
        NSLog(s, [])
    }
    
}
