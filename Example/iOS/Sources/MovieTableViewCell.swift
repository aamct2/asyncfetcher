//
//  MovieTableViewCell.swift
//  iOS Example
//
//  Created by Aaron McTavish on 29/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

import UIKit


final class MovieTableViewCell: UITableViewCell {


    // MARK: - Properties

    var representedId: String = ""


    // MARK: - Initializers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
