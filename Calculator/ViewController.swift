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
    
    var numQueue = Queue<Double>() // append and dequeue
    var numStack = Stack<Double>() // push and pop
    var operatorHitLast = false
    var decimalHit = false         // can have 1 or 0 decimals(".") per number
                                   // reset back to false with each operator, = or clear hit
    var decimal = 0.1              // .1, then * .1 for each subsequent decimal digit
                                  // reset back to .1 with each operator, = or clear hit
                                  // headvalue + (decimal * numberHit)
    
    @IBAction func num0ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 0.0)
    }
    @IBAction func num1ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 1.0)
    }
    @IBAction func num2ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 2.0)
    }
    @IBAction func num3ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 3.0)
    }
    @IBAction func num4ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 4.0)
    }
    @IBAction func num5ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 5.0)
    }
    @IBAction func num6ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 6.0)
    }
    @IBAction func num7ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 7.0)
    }
    @IBAction func num8ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 8.0)
    }
    @IBAction func num9ButtonClick(_ sender: Any) {
        
        numberButtonPress(num: 9.0)
    }
    
    func numberButtonPress(num: Double){
        // refactored code so each number button pressed calls this
        if !operatorHitLast{
            print("operatorHitLast = FALSE")
            if numQueue.head != nil{
                print("numQueue.head != NIL")
                //var headValue = numQueue.head?.value as! Double  // alternate cast method
                let headValue = Double((numQueue.tail?.value)!)
                print("headValue")
                //numQueue.dequeue()
                numQueue.removeLast()
                if headValue > -1.0{                // Do I need this check? Operator( < 0) would never be in the front of the queue..?
                    if decimalHit{
                        let newValue = headValue + (decimal * num)
                        numQueue.append(newElement: newValue)
                        print("New value pushed to queue = \(newValue)")
                        decimal *= 0.1
                    }
                    else{
                        let newValue = headValue * 10 + num
                        print("New value pushed to queue = \(newValue)")
                        numQueue.append(newElement: newValue)
                        print("Size of queue = \(numQueue.head == nil)")
                        print("Value of head = \(numQueue.head?.value)")
                    }
                }
            }
            else{
                if decimalHit{
                    // a 0.xxx number.
                    numQueue.append(newElement: decimal * num)    // append 0.num
                    decimal *= 0.1                              // for further decimal digits added
                }
                else{
                    numQueue.append(newElement: num)   //single digit to start operation (operand1)
                    print("pushing \(num) to queue - SINGLE DIGIT")
                }
            }
        }
        else{
            print("operatorHitLast = true")  // just push into queue - first digit to next operand
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
        let numAsString = String(Int(num))
        opLabel.text = opLabel.text! + numAsString
    }
    
    @IBAction func decimalButtonClick(_ sender: Any) {
        if !decimalHit {  //only 0 or 1 "." per operand
            opLabel.text = opLabel.text! + "."
            decimalHit = true
        }
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        resultLabel.text = ""
        opLabel.text = ""
        resultText.isHidden = true
        decimalHit = false
        decimal = 0.1
        
        //clear stack and queue for next operation
        while numQueue.head != nil{
            numQueue.dequeue()
        }
        while !numStack.items.isEmpty{
            numStack.pop()
        }
    }
    @IBAction func equalsButtonClick(_ sender: Any) {
        var operand1: Double
        var operand2: Double
        var op: Double
        
        decimalHit = false
        decimal = 0.1
        
        while !numStack.items.isEmpty{
            numQueue.append(newElement: numStack.pop())
        }
        
        while numQueue.head != nil{
            //var headValue = numQueue.head?.value as! Double
            let headValue = Double(numQueue.dequeue()!)
            print("headValue = \(headValue)")  // or switch to cast Double(...)
            if headValue > -1.0{
                numStack.push(headValue)
                //numQueue.dequeue()   // or just dequeue for headValue?
            }
            else{  // it's an operator
                op = headValue
                //numQueue.dequeue()
                operand2 = numStack.pop()
                operand1 = numStack.pop()
                print("Op: \(op) ; Oper1: \(operand1) ; Oper2: \(operand2)")
                
                if op == -1{
                    numStack.push(operand1 + operand2)
                }
                else if op == -2{
                    numStack.push(operand1 - operand2)
                }
                else if op == -3{
                    numStack.push(operand1 * operand2)
                }
                else{
                    numStack.push(operand1 / operand2)
                }
            }
        }
        //var result = Double(numStack.pop())
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
    }
    @IBAction func additionButtonClick(_ sender: Any) {
        opLabel.text = opLabel.text! + " + "
        operatorHitLast = true
        decimalHit = false
        decimal = 0.1
        
        if numStack.items.isEmpty{
            numStack.push(-1)
        }
        else{
            while !numStack.items.isEmpty{
                numQueue.append(newElement: numStack.pop())
            }
            numStack.push(-1)
        }
    }
    
    @IBAction func subtractionButtonClick(_ sender: Any) {
        opLabel.text = opLabel.text! + " - "
        operatorHitLast = true
        decimalHit = false
        decimal = 0.1
        
        if numStack.items.isEmpty{
            numStack.push(-2)
        }
        else{
            while !numStack.items.isEmpty{
                numQueue.append(newElement: numStack.pop())
            }
            numStack.push(-2)
        }
    }
    @IBAction func multiplicationButtonClick(_ sender: Any) {
        opLabel.text = opLabel.text! + " * "
        operatorHitLast = true
        decimalHit = false
        decimal = 0.1
        
        if numStack.items.isEmpty{
            numStack.push(-3)
        }
        else if numStack.topItem == -4 || numStack.topItem == -3{
            while numStack.topItem == -4 || numStack.topItem == -3{
                numQueue.append(newElement: numStack.pop())
            }
            numStack.push(-3)
        }
        else{
            numStack.push(-3)
        }
    }
    @IBAction func divisionButtonClick(_ sender: Any) {
        opLabel.text = opLabel.text! + " / "
        operatorHitLast = true
        decimalHit = false
        decimal = 0.1
        
        if numStack.items.isEmpty{
            numStack.push(-4)
        }
        else if numStack.topItem == -4 || numStack.topItem == -3{
            while numStack.topItem == -4 || numStack.topItem == -3{
                numQueue.append(newElement: numStack.pop())
            }
            numStack.push(-4)
        }
        else{
            numStack.push(-4)
        }
    }
    
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
