
import Foundation
import RxSwift
import RxCocoa

class ShoppingCart {
  static let sharedCart = ShoppingCart()
  // 1
  let chocolates: BehaviorRelay<[Chocolate]> = BehaviorRelay(value: [])
}

//MARK: Non-Mutating Functions
extension ShoppingCart {
  var totalCost: Float {
    // 2 behaviorRelay는 value가 있어 value 접근이 가능함
    return chocolates.value.reduce(0) {
      runningTotal, chocolate in
      return runningTotal + chocolate.priceInDollars
    }
  }
  
  var itemCountString: String {
    // 3
    guard chocolates.value.count > 0 else {
      return "🚫🍫"
    }
    
    //Unique the chocolates
    // 4
    let setOfChocolates = Set<Chocolate>(chocolates.value)
    
    //Check how many of each exists
    let itemStrings: [String] = setOfChocolates.map {
      chocolate in
      // reduce -> 모든 이벤트의 총합을 방출
      let count: Int = chocolates.reduce(0) {
        runningTotal, reduceChocolate in
        if chocolate == reduceChocolate {
          return runningTotal + 1
        }
        
        return runningTotal
      }
      
      return "\(chocolate.countryFlagEmoji)🍫: \(count)"
    }
    
    return itemStrings.joined(separator: "\n")
  }
}
