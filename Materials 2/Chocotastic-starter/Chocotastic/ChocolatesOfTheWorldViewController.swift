
import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
  @IBOutlet private var cartButton: UIBarButtonItem!
  @IBOutlet private var tableView: UITableView!
  // 7. just로 생성 -> 값에는 변경 사항이 없음 , 하나의 값만 방출함
  // Rx를 사용하는 이유는 변경 사항에 계속 반응하도록 하려고 하는 것인데
  // just는 변하지 않아서 이게 맞나?
  let europeanChocolates = Observable.just(Chocolate.ofEurope)
  private let disposeBag = DisposeBag()
}

//MARK: View Lifecycle
extension ChocolatesOfTheWorldViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chocolate!!!"
    setupCartObserver()
    setupCellConfiguration()
    setupCellTapHandling()
  }
}

//MARK: - Rx Setup
private extension ChocolatesOfTheWorldViewController {
  func setupCartObserver() {
    // 6.관찰하면서 자동으로 버튼의 타이틀을 바꿔줌
    // asObservable 사용 이유 -> subject는 observer와 observable 둘의 역할을 다 하는데, 외부에서 observer에 접근하지 못하도록 설정하며 observable에만 접근할 수 있도록 나눠서 접근 가능하도록 하기위함
    ShoppingCart.sharedCart.chocolates.asObservable()
      .subscribe(onNext: {
        [unowned self] chocolates in
        self.cartButton.title = "\(chocolates.count) \u{1f36b}"
      })
      .disposed(by: disposeBag)
  }
  
  // 8. Rx -> TableView
  // bind와 subscribe의 차이점
  // subscribe -> onNext, onError, onCompleted 다 받음
  // bind는 next만
  // 추가적으로 drive는 bind와 동일하지만 MainThread 보장 -> UI 업데이트 할 때 좋을 듯?
  func setupCellConfiguration() {
    europeanChocolates
      .bind(to: tableView.rx.items(cellIdentifier: ChocolateCell.Identifier, cellType: ChocolateCell.self)) {
        row, chocolate, cell in
        cell.configureWithChocolate(chocolate: chocolate)
      }
      .disposed(by: disposeBag)
  }
  
  // 9. didSelect
  func setupCellTapHandling() {
    tableView.rx.modelSelected(Chocolate.self)
      .subscribe(onNext: { [unowned self] chocolate in
     
        // newValue = 기존 데이터 + 클릭한 값
        
        let newValue = ShoppingCart.sharedCart.chocolates.value + [chocolate]
        ShoppingCart.sharedCart.chocolates.accept(newValue)
        
        print(newValue)
        
        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
          self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
  
  
  
}

// MARK: - SegueHandler
extension ChocolatesOfTheWorldViewController: SegueHandler {
  enum SegueIdentifier: String {
    case goToCart
  }
}
