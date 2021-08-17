//  Created by Ky Nguyen

import UIKit

class KNFixedCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var itemCount: Int { return 0 }
    var shouldGetDataViewDidLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupView()
        if shouldGetDataViewDidLoad {
            getData()
        }
    }
    
    init() { super.init(collectionViewLayout: UICollectionViewFlowLayout()) }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    func registerCells() {}
    func setupView() {}
    func getData() {}
    
    deinit { print("Deinit \(NSStringFromClass(type(of: self)))") }
}

extension KNFixedCollectionController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return itemCount }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { return UICollectionViewCell() }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 0 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return UIScreen.main.bounds.size }
}

class KNCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func setupView() { }
}

extension UICollectionView {
    func dequeue<T>(at indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
}
