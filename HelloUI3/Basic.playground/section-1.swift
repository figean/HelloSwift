// 学习swift语言 必备

import UIKit

var str = "学习swift语言"

println("***********")

func returnFifteen() -> Int {
    var y = 10;func add() {
        y += 5
    }
    add()
    return y
}

returnFifteen()

func makeIncrementer() -> (Int -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()
