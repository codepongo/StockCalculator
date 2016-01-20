//
//  Trade.swift
//  StockCalculator
//
//  Created by zuohaitao on 15/11/3.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

import Foundation
@objc(Trade)
class Trade:NSObject {
    func amount() -> Double {
        if needCalculate {
            self._amount =  self.price * Double(self.quantity);
            self.needCalculate = false
        }
        return self._amount
    }
    var needCalculate:Bool = false
    var _amount:Double = 0.000
    var quantity:Int  = 0 {
        didSet {
            self.needCalculate = true
        }
    }
    
    var price:Double = 0.000{
        didSet {
            self.needCalculate = true
        }
    }
}
