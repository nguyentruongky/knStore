//  Created by Ky Nguyen

import UIKit

class KNTableCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
    }
    static func wrap(view: UIView, space: UIEdgeInsets = .zero) -> KNTableCell {
        let cell = KNTableCell()
        cell.backgroundColor = .clear
        cell.addSubviews(views: view)
        view.fill(toView: cell, space: space)
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func setupView() { }
}

class KNFixedTableController: UITableViewController {
    var itemCount: Int { return 0 }
    var shouldGetDataViewDidLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        registerCells()
        setupView()
        if shouldGetDataViewDidLoad {
            getData()
        }
    }
    
    func setupView() {}
    func registerCells() {}
    func getData() {}
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return itemCount }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
}

class KNTableController: KNController {
    var itemCount: Int { return 0 }
    var rowHeight: CGFloat { return 100 }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    func registerCells() {}
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

extension KNTableController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return itemCount }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return rowHeight }
}

extension UITableView {
    convenience init(cells: [AnyClass], delegate: UITableViewDelegate? = nil, datasource: UITableViewDataSource? = nil) {
        self.init()
        for c in cells {
            register(c)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        self.dataSource = datasource
        self.delegate = delegate
    }
    convenience init(cells: [AnyClass], source: UITableViewDelegate&UITableViewDataSource) {
        self.init()
        for c in cells {
            register(c)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        dataSource = source
        delegate = source
    }
    func dequeue<T>(at indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
    func register(_ _class: AnyClass) {
        register(_class, forCellReuseIdentifier: String(describing: _class.self))
    }
    func layoutTableHeaderView() {
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width
        let temporaryWidthConstraints = headerView.width(headerWidth)
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        tableHeaderView = headerView
        headerView.removeConstraints([temporaryWidthConstraints])
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension UITableView {
    func resizeTableHeaderView(toSize size: CGSize) {
        guard let headerView = tableHeaderView else { return }
        guard headerView.frame.size != size else { return }
        headerView.frame.size = headerView.systemLayoutSizeFitting(size)
        tableHeaderView? = headerView
    }
    func getCell(id: String, at indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
    func setFooter(_ footer: UIView, height: CGFloat) {
        footer.height(height)
        tableFooterView = UIView()
        tableFooterView?.frame.size.height = height
        tableFooterView?.addSubview(footer)
        tableFooterView?.addConstraints(withFormat: "H:|[v0]|", views: footer)
        tableFooterView?.addConstraints(withFormat: "V:|[v0]", views: footer)
    }
    func setHeader(_ header: UIView, height: CGFloat) {
        if height == 0 {
            tableHeaderView = UIView()
            tableHeaderView?.addSubview(header)
            header.fill(toView: tableHeaderView!)
            return
        }
        header.height(height)
        tableHeaderView = UIView()
        tableHeaderView?.frame.size.height = height
        tableHeaderView?.addSubview(header)
        tableHeaderView?.addConstraints(withFormat: "H:|[v0]|", views: header)
        tableHeaderView?.addConstraints(withFormat: "V:|[v0]", views: header)
    }
    func updateHeaderHeight() {
        guard let headerView = tableHeaderView else { return }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame
        
        guard height != headerFrame.size.height else { return }
        headerFrame.size.height = height
        headerView.frame = headerFrame
        tableHeaderView = headerView
    }
    func updateFooterHeight() {
        guard let footerView = tableFooterView else { return }
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var footerFrame = footerView.frame
        
        guard height != footerFrame.size.height else { return }
        footerFrame.size.height = height
        footerView.frame = footerFrame
        tableFooterView = footerView
    }
}

extension UITableViewController {
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for cell in cells {
            UIView.animate(withDuration: 1.25, delay: 0.05 * Double(index),
                           usingSpringWithDamping: 0.65,
                           initialSpringVelocity: 0.0,
                           options: UIView.AnimationOptions(),
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
                           })
            index += 1
        }
    }
}
