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
    
    var purchase:Trade {
        return (self.buy == nil ? {self.buy = Trade();return self.buy!}() : self.buy!)
    }
    var sale:Trade {
        return (self.sell == nil ? {self.sell = Trade();return self.sell!}() : self.sell!)
    }

    func reset() {
        self.code = ""
        self.buy = nil
        self.sell = nil

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
    
    func calculateForGainOrLoss() {
        let (cost, commission_of_purchase, transfer_of_purchase, income, commission_of_sale, stamp,transfer_of_sale) = calculate()
        
        self.commission = commission_of_purchase + commission_of_sale
        
        self.transfer = transfer_of_purchase + transfer_of_sale
        
        self.stamp = stamp
        
        self.fee = self.commission + self.stamp
        
        if self.transfer != nil {
             self.fee += transfer!
        }
        
        self.result = income - cost
    }
    
    func calculateForBreakevenPrice() {
        self.sell = self.buy
        repeat {
            calculateForGainOrLoss()
            if self.result >= 0 {
                return
            }
            self.sell?.price += 0.01
        }while true
    }

    func calculateForPurchase()  {
        let (cost, commission_of_purchase, transfer_of_purchase, _, _, _,_) = calculate()
        
        self.commission =  commission_of_purchase
        
        self.transfer = transfer_of_purchase
        
        self.stamp = 0
        
        self.fee = self.commission
        
        if self.transfer != nil {
            self.fee += transfer!
        }
        
        self.result = cost
        
    }
    
    func calculateForSale() {
        let (_, _, _, income, commission_of_sale, stamp,transfer_of_sale) = calculate()
        
        self.commission = commission_of_sale
        
        self.transfer =  transfer_of_sale
        
        self.stamp = stamp
        
        self.fee = commission + stamp
        if self.transfer != nil {
            self.fee += transfer!
        }
        
        self.result = income
        
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
