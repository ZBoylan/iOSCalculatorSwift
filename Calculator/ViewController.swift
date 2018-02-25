//
//  ViewController.swift
//  Calculator
//
//  Created by Zachary Boylan on 2/12/18.
//  Copyright © 2018 Zachary Boylan. All rights reserved.
//

import UIKit

// implement a Stack
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

// implement a Queue
class QueueNode<T> {
    // note, not optional – every node has a value
    var value: T
    // but the last node doesn't have a next
    var next: QueueNode<T>? = nil
    // going to try adding two way link so can remove last element
    // or you need a pointer to iterate over queue ... but how to implement that?
    var prior: QueueNode<T>? = nil
    init(value: T) { self.value = value }
}

class Queue<T> {
    // note, these are both optionals, to handle
    // an empty queue
    var head: QueueNode<T>? = nil
    var tail: QueueNode<T>? = nil
    init() { }
}
extension Queue {
    // append is the standard name in Swift for this operation
    func append(newElement: T) {
        let oldTail = tail
        self.tail = QueueNode(value: newElement)
        if head == nil { head = tail }
        else {
            oldTail?.next = self.tail
            self.tail?.prior = oldTail
        }
    }
    func dequeue() -> T? {
        if let head = self.head {
            self.head = head.next
            if head.next == nil { tail = nil }
            return head.value
        }
        else {
            return nil
        }
    }
    
    func removeLast(){
        let valueRemoved = self.tail?.value
        print(valueRemoved)
        if self.tail?.prior != nil{
            self.tail = self.tail?.prior
        }
        else{
            // else if removing the single element in queue
            dequeue()
        }
    }

      // Need ptr iterator to do this
//    func printQueue(){
//        if head != nil{
//            var it: QueueNode<T>? = nil
//            it = head
//            while it?.value != nil{
//                print(head?.value)
//                it = head?.next
//            }
//        }
//        else{
//            print("queue is empty - can not print")
//        }
//    }
    
}


class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!  // will display result after = button hit
    @IBOutlet weak var opLabel: UILabel!      // will display entered operands and operators
    @IBOutlet weak var resultText: UILabel!   // the "Result =" box
    
    // Data storage - one queue and stack
    var numQueue = Queue<Double>() // append and dequeue
    var numStack = Stack<Double>() // push and pop
    
    var negativePressed =   false    // These next two for entering in negative numbers
    var operandStarted =    false    // See ^
    var operatorHitLast =   false    // These next two for error prevention
    var atLeastOneOperand = false
    var equalsHitLast =     false    // to restore opLabel after = button hit back to ""
    var decimalHit = false         // can have 1 or 0 decimals(".") per number
                                   // reset back to false with each operator, = or clear hit
    var decimal = 0.1              // .1, then * .1 for each subsequent decimal digit
                                  // reset back to .1 with each operator, = or clear hit
                                  // headvalue + (decimal * numberHit)
    
    @IBAction func num0ButtonClick(_ sender: Any) {
        numberButtonPress(number: 0.0)
    }
    @IBAction func num1ButtonClick(_ sender: Any) {
        numberButtonPress(number: 1.0)
    }
    @IBAction func num2ButtonClick(_ sender: Any) {
        numberButtonPress(number: 2.0)
    }
    @IBAction func num3ButtonClick(_ sender: Any) {
        numberButtonPress(number: 3.0)
    }
    @IBAction func num4ButtonClick(_ sender: Any) {
        numberButtonPress(number: 4.0)
    }
    @IBAction func num5ButtonClick(_ sender: Any) {
        numberButtonPress(number: 5.0)
    }
    @IBAction func num6ButtonClick(_ sender: Any) {
        numberButtonPress(number: 6.0)
    }
    @IBAction func num7ButtonClick(_ sender: Any) {
        numberButtonPress(number: 7.0)
    }
    @IBAction func num8ButtonClick(_ sender: Any) {
        numberButtonPress(number: 8.0)
    }
    @IBAction func num9ButtonClick(_ sender: Any) {
        numberButtonPress(number: 9.0)
    }
    
    func numberButtonPress(number: Double){
        var newValue: Double
        var num = number         //func arguments set to 'let' by default and passing literal
        
        // to check if negative number passed
        if negativePressed && !operandStarted && num != 0{
            num *= -1
            operandStarted = true
        }
        
        // check if we need to reset the opLabel back to ""
        if equalsHitLast{
            print("  **opLabel RESET")
            resultLabel.text = ""
            opLabel.text = ""
            resultText.isHidden = true
        }
        
        if !operatorHitLast && numQueue.head != nil{
            print("operatorHitLast = FALSE and numQueue.head != NIL")
                let tailValue = Double((numQueue.tail?.value)!)  //cast to Double
                print("headValue = \(tailValue)")
                numQueue.removeLast()
                if tailValue != -1.999999 && tailValue != -2.999999 && tailValue != -3.999999 && tailValue != -4.999999{   // Do I need this check? Operator( < 0) would never be in the front of the queue..?
                    if decimalHit{
                        if tailValue < 0{
                            // -2.3 = -2 - .3
                            newValue = tailValue - (decimal * num)
                        }
                        else{
                            // 4.5 = 4 + .5
                            newValue = tailValue + (decimal * num)
                        }
                        numQueue.append(newElement: newValue)
                        print("decimalHit - New value pushed to queue = \(newValue)")
                        decimal *= 0.1
                    }
                    else{
                        newValue = tailValue * 10 + num
                        print("New value pushed to queue = \(newValue)")
                        numQueue.append(newElement: newValue)
                        print("Size of queue = \(numQueue.head == nil)")
                        print("Value of head = \(numQueue.head?.value)")
                    }
                }
        }
        else{
            print("operatorHitLast = true or numQueue.head == NIL")  // just push into queue - first digit to next operand
            if decimalHit{
                numQueue.append(newElement: decimal * num)    // append 0.num
                decimal *= 0.1                              // for further decimal digits added
            }
            else{
                numQueue.append(newElement: num)   // single digit to start operation (operand1)
                print("pushing \(num) to queue - SINGLE DIGIT")
            }
        }
        
        operatorHitLast = false
        atLeastOneOperand = true
        equalsHitLast = false
        let numAsString = String(Int(abs(num)))     // get absolute value so doesnt print .-9
        print("numAsString = \(numAsString)")
        opLabel.text = opLabel.text! + numAsString
    }
    
    @IBAction func decimalButtonClick(_ sender: Any) {
        if !decimalHit {  //only 0 or 1 "." per operand
            opLabel.text = opLabel.text! + "."
            decimalHit = true
        }
    }
    @IBAction func negativeButtonClick(_ sender: Any) {
        if !negativePressed{
            negativePressed = true
            opLabel.text = opLabel.text! + "-"    // only show 0 or 1 negative signs per operand
            print("Negative PRESSED")
        }
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        resultLabel.text = ""
        opLabel.text = ""
        resultText.isHidden = true
        decimalHit = false
        decimal = 0.1
        operandStarted = false
        negativePressed = false
        atLeastOneOperand = false
        print("     ***CLEAR pressed***")
        
        //clear stack and queue for next operation
        while numQueue.head != nil{
            numQueue.dequeue()
        }
        while !numStack.items.isEmpty{
            numStack.pop()
        }
    }
    
    @IBAction func equalsButtonClick(_ sender: Any) {
        // to avoid input error -> ex. 4+=   or   just =
        if !operatorHitLast && numQueue.head != nil{
            var operand1: Double
            var operand2: Double
            var op: Double
            
            decimalHit = false     // These 4 needed here if clearButton always required for next op?
            decimal = 0.1
            operandStarted = false
            negativePressed = false
            atLeastOneOperand = false
            equalsHitLast = true
            
            while !numStack.items.isEmpty{
                numQueue.append(newElement: numStack.pop())
            }
            
            while numQueue.head != nil{
                //var headValue = numQueue.head?.value as! Double
                let headValue = Double(numQueue.dequeue()!)
                print("headValue = \(headValue)")  // or switch to cast Double(...)
                if headValue != -1.999999 && headValue != -2.999999 && headValue != -3.999999 && headValue != -4.999999{
                    numStack.push(headValue)
                }
                else{  // it's an operator
                    op = headValue
                    // for future operations with just one operand - will have to evaluate op first
                    //    examples - square root, trig, factorial
                    operand2 = numStack.pop()
                    operand1 = numStack.pop()
                    print("Op: \(op) ; Oper1: \(operand1) ; Oper2: \(operand2)")
                    
                    if op == -1.999999{
                        numStack.push(operand1 + operand2)
                    }
                    else if op == -2.999999{
                        numStack.push(operand1 - operand2)
                    }
                    else if op == -3.999999{
                        numStack.push(operand1 * operand2)
                    }
                    else{
                        numStack.push(operand1 / operand2)
                    }
                }
            }
            var result = ""
            if numStack.topItem?.truncatingRemainder(dividingBy: 1.0) != 0{  // % operator "unavailable here"
                result = String(round(1000*numStack.pop())/1000)  // sets 3 digits of precision - could make the user set # digits of precision
            }
            else{  // result is an integer - don't display the ".0"
                result = String(Int(numStack.pop()))
            }
            
            print("result = \(result)")
            resultText.isHidden = false
            resultLabel.text = result
            // carry result value over to next op or always clear it?
        }
    }
    
    @IBAction func additionButtonClick(_ sender: Any) {
        if !operatorHitLast && atLeastOneOperand{  // to prevent error/crash
            addSubtract(num: -1.999999)
        }
        // if equalsHitLast
        // put result value into queue then call addSubtract..?
    }
    
    @IBAction func subtractionButtonClick(_ sender: Any) {
        if !operatorHitLast && atLeastOneOperand{
            addSubtract(num: -2.999999)
        }
    }
    
    func addSubtract(num: Double){
        print("addSubtract() called")
        operatorHitLast = true
        decimalHit = false
        decimal = 0.1
        operandStarted = false
        negativePressed = false
        
        if num == -1.999999{
            opLabel.text = opLabel.text! + " + "
        }
        else{
            opLabel.text = opLabel.text! + " - "
        }
        
        if numStack.items.isEmpty{
            numStack.push(num)
        }
        else{
            while !numStack.items.isEmpty{
                numQueue.append(newElement: numStack.pop())
            }
            numStack.push(num)
        }
    }
    @IBAction func multiplicationButtonClick(_ sender: Any) {
        if !operatorHitLast && atLeastOneOperand{
            multiplyDivide(num: -3.999999)
        }
    }
    @IBAction func divisionButtonClick(_ sender: Any) {
        if !operatorHitLast && atLeastOneOperand{
            multiplyDivide(num: -4.999999)
        }
    }
    
    func multiplyDivide(num: Double){
        print("multiplyDivide() called")
        operatorHitLast = true
        decimalHit = false
        decimal = 0.1
        operandStarted = false
        negativePressed = false
        
        if num == -3.999999{
            opLabel.text = opLabel.text! + " * "
        }
        else{
            opLabel.text = opLabel.text! + " / "
        }
        
        if numStack.items.isEmpty{
            numStack.push(num)
        }
        else if numStack.topItem == -4.999999 || numStack.topItem == -3.999999{
            while numStack.topItem == -4.999999 || numStack.topItem == -3.999999{
                numQueue.append(newElement: numStack.pop())
            }
            numStack.push(num)
        }
        else{
            numStack.push(num)
        }
    }
    
    // future operators: (), exponent,
    //     unary: square root, factorial, trig(?)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultText.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
