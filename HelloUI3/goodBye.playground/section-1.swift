// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let possiableString : String? = "google"

println(possiableString!)

let possiableString2 : String! = "google plus"

println(possiableString2)

NSLog("is there any problem")

let b = 10
var a = 10
a != b

"hello," + "cookie"

9%2.5

for index in 1...5
{
    println(index)
}

let dog = "dog!??"

for codeUnit in dog.utf8
{
    println(codeUnit)
}

let ch : Character = "e"
//使用switch 语法
switch ch{
    case "1","b","c","g","h","i":
    println("okay")
    
    case "r","b","c","f","e","p":
    println("it is okay")
    default:
    println("default")
}