//
//  CustomTableViewCell.swift
//  CoreDataDemo
//
//  Created by Дмитрий Пономарев on 15.02.2023.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI properties
    
    let title = UILabel()
    let vc = ViewController()
    
    
    //MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
}

//MARK: - Private methods

private extension CustomTableViewCell {
    
    //MARK: - Setup
    
    func setup() {
        addViews()
        makeConstraints()
        setupViews()
    }
    
    //MARK: - addViews
    
    func addViews() {
        contentView.addSubview(title)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {

    }
}
