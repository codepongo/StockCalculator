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
        return NSUserDefaults.standardUserDefaults().floatForKey(key);
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setFloat((value as! Float), forKey: key)
    }
    var stamp:Float {
        get {
            return (self.valueForKey(__FUNCTION__) as! Float)
        }

    }
    var transfer:Float {
        get {
            return (self.valueForKey(__FUNCTION__) as! Float)
        }

    }
    var commission:Float {
        get {
            return (self.valueForKey(__FUNCTION__) as! Float)
        }
    }
}