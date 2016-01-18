//
//  CalculateBrain.swift
//  StockCalculator
//
//  Created by zuohaitao on 15/11/22.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

import Foundation

@objc(CalculateBrain)
class CalculateBrain:NSObject {
    var code:String = ""
    var buy:Trade = Trade()
    var sell:Trade? = nil
    var rate:Rate = Rate()
    var commission:Float = 0.000
    var stamp:Float = 0.000
    var transfer:Float? = nil
    var fee:Float = 0.000
    var result:Float = 0.000
    var inSZ:Bool {
        get {
            return self.transfer == nil
        }
        set {
            if newValue {
                self.transfer = nil
            }
            else {
                self.transfer = 0.000
            }
        }
    }
    var calculateForGainOrLoss:Bool {
        set {
            if newValue {
                self.sell = Trade()
            }
            else {
                self.sell = nil;
            }
        }
        get {
            return (self.sell != nil)
        }
    }
    func reset() {
        self.code = ""
        self.buy.price = 0.000
        self.buy.quantity = 0
        if self.sell != nil {
            self.sell?.price = 0.000
            self.sell?.quantity = 0
        }
        self.commission = 0.000
        self.stamp = 0.000
        if self.transfer != nil {
            self.transfer = 0.000
        }
        self.fee = 0.000
        self.result = 0.000
    }
    func commission(amount:Float) -> Float {
        if amount == 0 {
            return 0.000
        }
        if amount < 10000.00 {
            return 5.000
        }
        
        return (amount * (self.rate.commission / 1000))
        
    }
    func stamp(amount:Float) -> Float{
        if amount == 0 {
            return 0.000
        }
        if amount < 1000.00 {
            return 1.000
        }
        return amount * (self.rate.stamp / 1000)
    }
    func transfer(quantity:Float) -> Float {
        if self.inSZ {
            return 0.000
        }
        var transfer:Float = (quantity % 1000 == 0) ? 0: 1
        transfer += (quantity / 1000) * self.rate.transfer
        return transfer
    }
    
    func calculate() {
        let r : (Float, Float, Float?, Float, Float)
        if self.sell == nil {
            r = self.calculateForBreakevenPrice()
            
        }
        else {
            r = self.calculateForGainOrLoss()
        }
        self.commission = r.0
        self.stamp = r.1
        if self.transfer != nil {self.transfer = r.2}
        self.fee = r.3
        self.result = r.4
    }
    
    func calculateForBreakevenPrice() -> (Float, Float, Float?, Float, Float) {
        let sell:Trade = Trade()
        sell.quantity = self.buy.quantity
        sell.price = self.buy.price
        repeat {
            let result = calculateForGainOrLoss(sell)
            if result.4 >= 0 {
                return (result.0, result.1, result.2, result.3, sell.price)
            }
            sell.price += 0.01
        }while true
    }
    
    func calculateForGainOrLoss(var s:Trade? = nil) -> (Float, Float, Float?, Float, Float) {
        if s == nil {
            s = self.sell
        }
        let commission = self.commission(self.buy.amount()) + self.commission(s!.amount())
        let stamp = self.stamp(s!.amount())
        var transfer:Float = 0.000
        if !self.inSZ {
            transfer = self.transfer(Float(self.buy.quantity)) + self.transfer(Float(s!.quantity))
        }

        let fee:Float = commission + stamp + transfer
        let cost:Float = self.buy.amount() + fee
        let income = s!.amount()
        let result = income - cost

        return (commission, stamp, transfer, fee, result)
    }
    func transferAsFloat() -> Float {
        if self.transfer == nil {
            return 0.000
        }
        else {
            return self.transfer!
        }
    }

    
}