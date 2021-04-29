// 学习swift语言 必备

import UIKit

var str = "学习swift语言"


let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}
var reversed = sorted(names, backwards)

let numarr = [3,4,7,9,10]

func backsort(a1:NSInteger , a2:NSInteger) ->Bool{

    return a1 > a2
}

var newsortarr = sorted(numarr,backsort)


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
