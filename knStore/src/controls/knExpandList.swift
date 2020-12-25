//
//  knExtendList.swift
//  knStore
//
//  Created by Ky Nguyen Coinhako on 12/11/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit
class knExpandItem<U> {
    var isExpand: Bool = false
    var data = [U]()
    init(data: [U]) {
        self.data = data
    }
}

class knExpandItemCell<U>: knListCell<U> { }
class knExpandList<Cell: knExpandItemCell<U>, Item: knExpandItem<U>, U>: KNController, UITableViewDelegate, UITableViewDataSource {
    
    var sections = [String]()
    var rowHeight: CGFloat = 48
    var datasource = [String: Item]() { didSet { tableView.reloadData() }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        }()
    
    override func setupView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
    }
    
    func mapData(dictionary: [String: [U]]){
        let map = dictionary.mapValues({ return knExpandItem(data: $0) })
        sections = Array(dictionary.keys)
        sections.sort()
        datasource = map as! [String: Item]
    }
    
    @objc func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return makeHeaderView(at: section) }
    func makeHeaderView(at index: Int) -> UIView? { return nil }
    
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return rowHeight }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = datasource[sections[section]] else { return 0 }
        return items.isExpand ? items.data.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(id: "cell", at: indexPath) as! Cell
        let key = sections[indexPath.section]
        let dt = datasource[key]?.data[indexPath.row]
        cell.data = dt
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)}
    func didSelectRow(at index: IndexPath) {}
    
    @objc func toggleSection(button: UIButton) {
        let section = sections[button.tag]
        guard let dataInSection = datasource[section]?.data else { return }
        let indexPaths = dataInSection.indices.map({ return IndexPath(row: $0, section: button.tag) })
        let isExpand = datasource[section]!.isExpand
        datasource[section]?.isExpand = !isExpand
        if isExpand == true {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
}

