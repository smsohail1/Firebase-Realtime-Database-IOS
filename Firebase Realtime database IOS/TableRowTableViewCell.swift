//
//  TableRowTableViewCell.swift
//  Firebase Realtime database IOS
//
//  Created by Abdul Ahad on 7/20/17.
//  Copyright © 2017 plash. All rights reserved.
//

import UIKit

class TableRowTableViewCell: UITableViewCell {

    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
