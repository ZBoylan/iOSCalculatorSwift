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
        else { oldTail?.next = self.tail }
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
}



class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!  // will display result after = button hit
    @IBOutlet weak var opLabel: UILabel!      // will display entered operands and operators
    @IBOutlet weak var resultText: UILabel!   // the "Result =" box
    
    
    var numQueue = Queue<Double>() // append and dequeue
    var numStack = Stack<Double>(); // push and pop
    
    @IBAction func num0ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 0)
        print("pushing 0 to queue")
        opLabel.text = opLabel.text! + "0"
    }
    @IBAction func num1ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 1)
        print("pushing 1 to queue")
        opLabel.text = opLabel.text! + "1"
    }
    @IBAction func num2ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 2)
        print("pushing 2 to queue")
        opLabel.text = opLabel.text! + "2"
    }
    @IBAction func num3ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 3)
        print("pushing 3 to queue")
        opLabel.text = opLabel.text! + "3"
    }
    @IBAction func num4ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 4)
        print("pushing 4 to queue")
        opLabel.text = opLabel.text! + "4"
    }
    @IBAction func num5ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 5)
        print("pushing 5 to queue")
        opLabel.text = opLabel.text! + "5"
    }
    @IBAction func num6ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 6)
        print("pushing 6 to queue")
        opLabel.text = opLabel.text! + "6"
    }
    @IBAction func num7ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 7)
        print("pushing 7 to queue")
        opLabel.text = opLabel.text! + "7"
    }
    @IBAction func num8ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 8)
        print("pushing 8 to queue")
        opLabel.text = opLabel.text! + "8"
    }
    @IBAction func num9ButtonClick(_ sender: Any) {
        numQueue.append(newElement: 9)
        print("pushing 9 to queue")
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
            var headValue = numQueue.head?.value as! Double
            print("headValue = \(headValue)")  // or switch to cast Double(...)
            if headValue > -1.0{
                numStack.push(headValue)
                numQueue.dequeue()
            }
            else{  // it's an operator
                op = headValue
                numQueue.dequeue()
                operand1 = numStack.pop()
                operand2 = numStack.pop()
                
                if op == -1{
                    numStack.push(operand2 + operand1)
                }
                else if op == -2{
                    numStack.push(operand2 - operand1)
                }
                else if op == -3{
                    numStack.push(operand2 * operand1)
                }
                else{
                    numStack.push(operand2 / operand1)
                }
            }
        }
        var result = String(numStack.pop())
        print("result = \(result)")
        resultText.isHidden = false
        resultLabel.text = result
    }
    @IBAction func additionButtonClick(_ sender: Any) {
        opLabel.text = opLabel.text! + "+"
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

