//
//  TableViewCellForGasStation.swift
//  iZapravka
//
//  Created by user on 28.01.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit

class TableViewCellForGasStation: UITableViewCell {
//hrgb;24tjn24ltg,
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var literLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var wayLabel: UILabel!
    @IBOutlet weak var gasStationImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
