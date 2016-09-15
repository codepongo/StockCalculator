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
    var commission:Double = 0.00
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
                self.transfer = 0.00
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
        self.buy.price = 0.00
        self.buy.quantity = 0
        if let sell = self.sell {
            sell.price = 0.000
            sell.quantity = 0
        }

        self.commission = 0.00
        self.stamp = 0.00
        if self.transfer != nil {
            self.transfer = 0.00
        }
        self.fee = 0.00
        self.result = 0.00
    }
    func commission(amount:Double) -> Double {
        if amount == 0 {
            return 0.00
        }
        
        let banker:NSDecimalNumberHandler =
        NSDecimalNumberHandler.init(roundingMode:NSRoundingMode.RoundPlain, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)

        let c = NSDecimalNumber.init(double: amount).decimalNumberByMultiplyingBy(NSDecimalNumber.init(double: self.rate.commission).decimalNumberByDividingBy(NSDecimalNumber.init(integer: 1000)), withBehavior: banker).doubleValue
       
        if c < 5.00 {
            return 5.00
        }
        return c
    }
    func stamp(amount:Double) -> Double{
        if amount == 0 {
            return 0.00
        }
        
        let banker:NSDecimalNumberHandler =
        NSDecimalNumberHandler.init(roundingMode:NSRoundingMode.RoundPlain, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
        
        
        let stamp = NSDecimalNumber.init(double: amount).decimalNumberByMultiplyingBy(NSDecimalNumber.init(double: self.rate.stamp).decimalNumberByDividingBy(NSDecimalNumber.init(integer: 1000)), withBehavior: banker).doubleValue
        if stamp < 1.00 {
            return 1.00
        }
        return stamp

    }


    func transfer(account:Double) -> Double {
        if self.inSZ {
            return 0.00
        }
        let banker:NSDecimalNumberHandler =
        NSDecimalNumberHandler.init(roundingMode:NSRoundingMode.RoundPlain, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
        
        
        return NSDecimalNumber.init(double: account).decimalNumberByMultiplyingBy(NSDecimalNumber.init(double: self.rate.transfer).decimalNumberByDividingBy(NSDecimalNumber.init(integer: 1000)), withBehavior: banker).doubleValue
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
        let commission_of_sale = self.commission(s!.amount())
        let commission =  commission_of_purchase + commission_of_sale

        
        let transfer_of_purchase = self.transfer(self.buy.amount())
        let transfer_of_sale = self.transfer(s!.amount())
        let transfer = transfer_of_purchase + transfer_of_sale

        
        let stamp = self.stamp(s!.amount())

        let fee = commission + stamp + transfer
        

        let cost =  self.buy.amount() + commission_of_purchase + transfer_of_purchase
        
        let income = s!.amount() - stamp - commission_of_sale - transfer_of_sale
        
        let result = income - cost

        print("purchase:\(cost), commission:\(commission_of_purchase), transfer:\(transfer_of_purchase)")
        print("sale:\(income), commission:\(commission_of_sale), transfer:\(transfer_of_sale), stamp:\(stamp)")
        
        return (commission, stamp, transfer, fee, result)
    }
    func transferAsFloat() -> Double {
        if self.transfer == nil {
            return 0.00
        }
        else {
            return self.transfer!
        }
    }

    
}