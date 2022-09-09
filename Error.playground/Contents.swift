import UIKit
 
struct Dish {
    let product: Product
    var count: Int
    var coocked: CookingMethod
    var platesNeed: Int
    
}
 
struct Product {
    let name: String
}
 
enum CookingMethod {
    case fresh
    case boiled
    case fried
}
 
enum KitchenError: Error {
    case invalidSelection // блюда нет в меню
    case outOfStock       //нет в наличии
    case insufficientPlate(platesNeed: Int) //недостаточно чистых тарелок, передаем недостаточное количество
    case invalidCookingMethod //не правильный способ приготовления
}
 
class Kitchen {
    var fridge = ["Eggs": Dish(product: Product(name: "Eggs"), count: 10, coocked: .fresh, platesNeed: 5),
                  "Potato": Dish(product: Product(name: "Potato"), count: 7, coocked: .boiled, platesNeed: 2),
                  "Meat": Dish(product: Product(name: "Meat"), count: 0, coocked: .fried, platesNeed: 3)
    ]
    var platesCount = 8
    
    func makeFood(foodName name: String, coocked: CookingMethod) -> (Product?, KitchenError?) {
       
        //такого блюда нет в холодильнике
        guard let item = fridge[name] else {
            return (nil, KitchenError.invalidSelection)
        }
        //блюдо закончилось
        guard item.count > 0  else {
            return (nil, KitchenError.outOfStock)
        }
        //не тот способ приготовления
        guard item.coocked == coocked else {
            return (nil, KitchenError.invalidCookingMethod)
        }
        //не достаточно тарелок
        guard item.platesNeed <= platesCount else {
            return (nil, KitchenError.insufficientPlate(platesNeed: item.platesNeed - platesCount))
        }
        platesCount -= item.platesNeed
        var newItem = item
        newItem.count -= 1
        fridge[name] = newItem
        return (newItem.product, nil)
    }
}
 
let kitchen = Kitchen()
//let cook1 = kitchen.makeFood(foodName: "Milk", coocked: .boiled)
let cook1 = kitchen.makeFood(foodName: "Eggs", coocked: .fresh)
let cook2 = kitchen.makeFood(foodName: "Eggs", coocked: .boiled)
let cook3 = kitchen.makeFood(foodName: "Meat", coocked: .fried)
let cook4 = kitchen.makeFood(foodName: "Potato", coocked: .boiled)
 
if let product = cook1.0 {
    print("Мы выбрали: \(product.name)")
} else if let error = cook1.1 {
    print("Произошла ошибка: \(error)") }
 
if let product = cook2.0 {
print("Мы выбрали: \(product.name)")
} else if let error = cook2.1 {
    print("Произошла ошибка: \(error)") }
 
if let product = cook3.0 {
print("Мы выбрали: \(product.name)")
} else if let error = cook3.1 {
    print("Произошла ошибка: \(error)") }
 
if let product = cook4.0 {
print("Мы выбрали: \(product.name)")
} else if let error = cook4.1 {
    print("Произошла ошибка: \(error)") }
