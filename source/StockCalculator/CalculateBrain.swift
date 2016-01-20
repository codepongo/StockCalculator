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
    var commission:Double = 0.000
    var stamp:Double = 0.00
    var transfer:Double? = nil
    var fee:Double = 0.00
    var result:Double = 0.00
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
    func commission(amount:Double) -> Double {
        if amount == 0 {
            return 0.00
        }
        
        let c = (amount * (self.rate.commission / 1000))
        
        if c < 5.000 {
            return 5.00
        }
        return round(c * 100) / 100.00
    }
    func stamp(amount:Double) -> Double{
        if amount == 0 {
            return 0.00
        }
        let s = round((amount * (self.rate.stamp / 1000)) * 100.00) / 100.00

        if s < 1.00 {
            return 1.00
        }
        return s
    }

    func transfer(acount:Double) -> Double {
        if self.inSZ {
            return 0.000
        }
        return round((acount * (self.rate.transfer / 1000)) * 100.00) / 100.00
    }
    
    func calculate() {
        let r : (Double, Double, Double?, Double, Double)
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
    
    func calculateForBreakevenPrice() -> (Double, Double, Double?, Double, Double) {
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
    
    func calculateForGainOrLoss(var s:Trade? = nil) -> (Double, Double, Double?, Double, Double) {
        if s == nil {
            s = self.sell
        }
        let commission_of_purchase = self.commission(self.buy.amount())
        let commission_of_sale = self.commission(self.buy.amount())
        let commission =  commission_of_purchase + commission_of_sale
        
        let stamp = self.stamp(s!.amount())
        
        let transfer_of_purchase = self.transfer(self.buy.amount())
        let transfer_of_sale = self.transfer(s!.amount())
        let transfer:Double = transfer_of_purchase + transfer_of_sale

        let fee:Double = commission + stamp + transfer
        let cost:Double = self.buy.amount() + fee
        let income = s!.amount()
        let result = income - cost

        return (commission, stamp, transfer, fee, result)
    }
    func transferAsFloat() -> Double {
        if self.transfer == nil {
            return 0.000
        }
        else {
            return self.transfer!
        }
    }

    
}