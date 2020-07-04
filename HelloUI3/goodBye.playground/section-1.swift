// Playground - noun: a place where people can play

import UIKit


var str = "我们开始学习swift中得playground不需要编译 可以直接执行"
println("this is a str : (\(str))")
let possiableString : String? = "google"

println(possiableString!)

let possiableString2 : String! = "google plus"

println(possiableString2)

//使用函数
func getGas() ->(Double ,Double, Double){
    return (1.0,2.0,3.0)
}

getGas()


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
//写函数
func sumOf(numbers:Int...) ->Int{
    var sum = 0
    for number in numbers{
        sum += number
    }
    return sum
}
sumOf(42,32,21)

//枚举值
enum Suit{
case Spades,Hearts,Diamonds,Clubs
    
    func simpeDescrition() ->String{
        switch self{
        case .Spades: return "spaders"
        case .Hearts: return "hearts"
        case .Clubs: return "clubs"
        case .Diamonds: return "diamonds"
        }
    }
}

let hearts = Suit.Hearts

let heartsDesctiption = hearts.simpeDescrition()

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

let yetAnotherPoint = (1,-1)
switch yetAnotherPoint{
case let(x,y) where x == y:
    println("(\(x),\(y)) is on the line x == y")
case let (x,y) where x == -y:
    println("(\(x),\(y)) is not on the line x == -y")
case let (x,y):
    println("(\(x), \(y)) is just some arbitrary point x==y")
}
