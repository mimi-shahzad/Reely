//
//  Array.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/25/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation
extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }
        return self[index]
    }
    
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
    
}
