

import UIKit

import RxCocoa
import RxSwift

class CartViewController: UIViewController {
  @IBOutlet private var checkoutButton: UIButton!
  @IBOutlet private var totalItemsLabel: UILabel!
  @IBOutlet private var totalCostLabel: UILabel!
}

//MARK: - View lifecycle
extension CartViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Cart"
    configureFromCart()
  }
}

//MARK: - IBActions
extension CartViewController {
  @IBAction func reset() {
    // 5. 왜 accept? -> chocolates이 BehaviorRelay이고 accpet는 onNext를 포함함
    // reset 버튼을 누르면 빈 배열로 초기화 한다는 소리?
    ShoppingCart.sharedCart.chocolates.accept([])
    let _ = navigationController?.popViewController(animated: true)
  }
}

//MARK: - Configuration methods
private extension CartViewController {
  func configureFromCart() {
    guard checkoutButton != nil else {
      //UI has not been instantiated yet. Bail!
      return
    }
    
    let cart = ShoppingCart.sharedCart
    totalItemsLabel.text = cart.itemCountString
    
    let cost = cart.totalCost
    totalCostLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cost)
    
    //Disable checkout if there's nothing to check out with
    checkoutButton.isEnabled = (cost > 0)
  }
}
