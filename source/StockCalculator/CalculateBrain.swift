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
    var buy:Trade? = nil
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

//    var calculateForGainOrLoss:Bool {
//        set {
//            if newValue {
//                self.sell = Trade()
//            }
//            else {
//                self.sell = nil;
//            }
//        }
//        get {
//            return (self.sell != nil)
//        }
//    }
    
//    var mode:Int {
//        set {
//            switch(newValue) {
//                case 0:
//                    self.buy = Trade()
//                    self.sell = Trade()
//                    break
//                case 1:
//                case 2:
//                    self.buy = Trade()
//                    self.sell = nil
//                    break
//                case 2:
//                    self.buy = nil
//                    self.sell = Trade()
//                    break
//                
//            }
//        }
//        get {
//
//        }
//    }
    func reset() {
        self.code = ""
        self.buy?.price = 0.00
        self.buy?.quantity = 0
        self.sell?.price = 0.00
        self.sell?.quantity = 0

        self.commission = 0.00
        self.stamp = 0.00
        self.transfer? = 0.00
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
    
//    func calculate() {
//        let r : (Double, Double, Double?, Double, Double)
//        if self.sell == nil {
//            r = self.calculateForBreakevenPrice()
//            
//        }
//        else {
//            r = self.calculateForGainOrLoss()
//        }
//        self.commission = r.0
//        self.stamp = r.1
//        if self.transfer != nil {self.transfer = r.2}
//        self.fee = r.3
//        self.result = r.4
//    }
    
//    func calculateForBreakevenPrice() -> (Double, Double, Double?, Double, Double) {
//        self.sell = Trade()
//        let sell:Trade = Trade()
//        self.sell?.quantity = self.buy?.quantity
//        self.sell?.price = self.buy?.price
//        repeat {
//            let result = calculateForGainOrLoss(sell)
//            if result.4 >= 0 {
//                return (result.0, result.1, result.2, result.3, sell.price)
//            }
//            sell.price += 0.01
//        }while true
//    }
    func calculate() -> (Double, Double, Double, Double, Double, Double, Double) {
        let commission_of_purchase:Double
        let transfer_of_purchase:Double
        let cost:Double
        if let purchase:Double = self.buy?.amount() {
            commission_of_purchase = self.commission(purchase)
            transfer_of_purchase = self.transfer(purchase)
            cost = purchase + commission_of_purchase + transfer_of_purchase
        }
        else {
            commission_of_purchase = 0
            transfer_of_purchase = 0
            cost = 0
        }

        let commission_of_sale:Double
        let transfer_of_sale:Double
        let stamp:Double
        let income:Double
        if let sale:Double = self.sell?.amount() {
            commission_of_sale = self.commission(sale)
            transfer_of_sale = self.transfer(sale)
            stamp = self.stamp(sale)
            income = sale - stamp - commission_of_sale - transfer_of_sale
        }
        else {
            commission_of_sale = 0
            transfer_of_sale = 0
            income = 0
            stamp = 0
        }
        //print("purchase:\(cost), commission:\(commission_of_purchase), transfer:\(transfer_of_purchase)")
        //print("sale:\(income), commission:\(commission_of_sale), stamp:\(stamp), transfer:\(transfer_of_sale)")
        
        return (cost, commission_of_purchase, transfer_of_purchase, income, commission_of_sale, stamp,transfer_of_sale)
    }
    
//    func calculateForGainOrLoss() -> (Double, Double, Double?, Double, Double) {
//        let (cost, commission_of_purchase, transfer_of_purchase, income, commission_of_sale, stamp,transfer_of_sale) = calculate()
//        
//        let commission =  commission_of_purchase + commission_of_sale
//
//        let transfer = transfer_of_purchase + transfer_of_sale
//
//        let fee = commission + stamp + transfer
//        
//        let result = income - cost
//
//        return (commission, stamp, transfer, fee, result)
//    }
    func transferAsFloat() -> Double {
        if self.transfer == nil {
            return 0.00
        }
        else {
            return self.transfer!
        }
    }

    
}
