//
//  Globals.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 3/1/18.
//  Copyright © 2018 Bala. All rights reserved.
//

import Foundation

func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    
    #if DEBUG
        var idx = items.startIndex
        let endIdx = items.endIndex
        
        repeat {
            Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
            idx += 1
        }
            while idx < endIdx
    #endif
}
