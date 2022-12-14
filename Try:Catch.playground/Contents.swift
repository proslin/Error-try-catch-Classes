import UIKit
import Darwin
 
struct Dish {
    ///блюдо
    let product: Product
    ///количество
    var count: Int
    /// способ приготовления
    var coocked: CookingMethod
    //сколько тарелок нужно для сервировки
    var platesNeed: Int
    
}
 
struct Product {
    ///наименование продукта
    let name: String
}
 
enum CookingMethod {
    ///свежий
    case fresh
    ///вареный
    case boiled
    ///жареный
    case fried
}
 
enum KitchenError: Error {
    /// блюда нет в меню
    case invalidSelection
    ///нет в наличии
    case outOfStock
    ///недостаточно чистых тарелок, передаем недостаточное количество
    case insufficientPlate(platesNeed: Int)
    ///не правильный способ приготовления
    case invalidCookingMethod
}
 
enum EatError: Error {
    /// человек не найден
    case personNotFound
}
 
let favouriteFood = [
    "father": "Meat",
    "mother": "Eggs",
    "son": "Potato"
]
 
class Kitchen {
    var fridge = ["Eggs": Dish(product: Product(name: "Eggs"), count: 10, coocked: .fresh, platesNeed: 5),
                  "Potato": Dish(product: Product(name: "Potato"), count: 7, coocked: .boiled, platesNeed: 2),
                  "Meat": Dish(product: Product(name: "Meat"), count: 0, coocked: .fried, platesNeed: 3)
    ]
    var platesCount = 8
    
    func makeFood(foodName name: String, coocked: CookingMethod) throws -> Product {
       
        //такого блюда нет в меню
        guard let item = fridge[name] else {
            
            throw KitchenError.invalidSelection
        }
        //блюдо закончилось
        guard item.count > 0  else {
            throw KitchenError.outOfStock
        }
        //не тот способ приготовления
        guard item.coocked == coocked else {
            throw KitchenError.invalidCookingMethod
        }
        //не достаточно тарелок
        guard item.platesNeed <= platesCount else {
            throw KitchenError.insufficientPlate(platesNeed: item.platesNeed - platesCount)
        }
        platesCount -= item.platesNeed
        var newItem = item
        newItem.count -= 1
        fridge[name] = newItem
        return newItem.product
    }
}
 
func takeFavouriteFood(person: String, kitchen: Kitchen, coocked: CookingMethod) throws -> Product {
    guard let foodName = favouriteFood[person] else {
        throw EatError.personNotFound
    }
    
    return try kitchen.makeFood(foodName: foodName, coocked: coocked)
}
 
 
let kitchen = Kitchen()
 
 
 
do {
    //let take = try takeFavouriteFood(person: "father", kitchen: kitchen, coocked: .boiled)
    //let take = try takeFavouriteFood(person: "mother", kitchen: kitchen, coocked: .boiled)
    let take = try takeFavouriteFood(person: "son", kitchen: kitchen, coocked: .boiled)
    
    print("Взяли продукт \(take.name)")
} catch KitchenError.invalidSelection {
    print("Такого продукта нет в меню")
} catch KitchenError.outOfStock {
    print("Продукт закончился")
} catch KitchenError.insufficientPlate( let platesNeed){
    print("Недостаточно чистых тарелок. Необходимо еще \(platesNeed) тарелок")
} catch KitchenError.invalidCookingMethod {
    print("Способ приготовления отличается от выбранного")
} catch EatError.personNotFound {
    print("Человек не найден")
} catch let error {
    print(error.localizedDescription)
}

