//
//  SectionList.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 10/11/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

class KNSectionList<C: KNListCell<U>, U>: KNController, UITableViewDelegate, UITableViewDataSource {
    var sections = [String]()
    var datasource = [String: [U]]() { didSet { tableView.reloadData() }}
    var rowHeight = UITableView.automaticDimension
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func setupView() {
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = 100
        tableView.register(C.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = sections[section]
        return datasource[char]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! C
        let char = sections[indexPath.section]
        cell.data = datasource[char]![indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return rowHeight }
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? { return sections }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sections[section] }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)}
    func didSelectRow(at index: IndexPath) {}
}
