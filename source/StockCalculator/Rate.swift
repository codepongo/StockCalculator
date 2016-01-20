//
//  Rate.swift
//  StockCalculator
//
//  Created by zuohaitao on 15/11/20.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

import Foundation

@objc(Rate)
class Rate:NSObject {
    override func valueForKey(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().doubleForKey(key);
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setDouble((value as! Double), forKey: key)
    }
    var stamp:Double {
        get {
            return (self.valueForKey(__FUNCTION__) as! Double)
        }

    }
    var transfer:Double {
        get {
            return (self.valueForKey(__FUNCTION__) as! Double)
        }

    }
    var commission:Double {
        get {
            return (self.valueForKey(__FUNCTION__) as! Double)
        }
    }
}