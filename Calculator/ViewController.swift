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
    
    @IBAction func num0ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 0)
        print("pushing 0 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "0"
    }
    @IBAction func num1ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 1)
        print("pushing 1 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "1"
    }
    @IBAction func num2ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 2)
        print("pushing 2 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "2"
    }
    @IBAction func num3ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 3)
        print("pushing 3 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "3"
    }
    @IBAction func num4ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 4)
        print("pushing 4 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "4"
    }
    @IBAction func num5ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 5)
        print("pushing 5 to queue")
        //numQueue.printQueue()
        operatorHitLast = false
        opLabel.text = opLabel.text! + "5"
    }
    @IBAction func num6ButtonClick(_ sender: Any) {
        if !operatorHitLast{
            print("operatorHitLast = FALSE")
            if numQueue.head != nil{
                print("numQueue.head != NIL")
                //var headValue = numQueue.head?.value as! Double
                let headValue = Double((numQueue.tail?.value)!)
                print("headValue")
                //numQueue.dequeue()
                numQueue.removeLast()
                if headValue > -1.0{
                    let newValue = headValue * 10 + 6
                    print("New value pushed to queue = \(newValue)")
                    numQueue.append(newElement: newValue)
                    print("Size of queue = \(numQueue.head == nil)")
                    print("Value of head = \(numQueue.head?.value)")
                }
            }
            else{
                numQueue.append(newElement: 6)   // single digit
                print("pushing 6 to queue - SINGLE DIGIT")
            }
        }
        else{
            print("operatorHitLast = true")  // so just push into queue
            numQueue.append(newElement: 6)
        }
        
        operatorHitLast = false
        opLabel.text = opLabel.text! + "6"
        
    }
    @IBAction func num7ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 7)
        print("pushing 7 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "7"
    }
    @IBAction func num8ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 8)
        print("pushing 8 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "8"
    }
    @IBAction func num9ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 9)
        print("pushing 9 to queue")
        operatorHitLast = false
        opLabel.text = opLabel.text! + "9"
    }
    @IBAction func clearButtonClick(_ sender: Any) {
        resultLabel.text = ""
        opLabel.text = ""
        resultText.isHidden = true
        
        //clear stack and queue
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
        
        while !numStack.items.isEmpty{
            numQueue.append(newElement: numStack.pop())
        }
        
        while numQueue.head != nil{
            // Bug - numQueue is never clearing
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
        let result = String(numStack.pop())
        print("result = \(result)")
        resultText.isHidden = false
        resultLabel.text = result
    }
    @IBAction func additionButtonClick(_ sender: Any) {
        opLabel.text = opLabel.text! + "+"
        operatorHitLast = true
        
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
        opLabel.text = opLabel.text! + "-"
        operatorHitLast = true
        
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

