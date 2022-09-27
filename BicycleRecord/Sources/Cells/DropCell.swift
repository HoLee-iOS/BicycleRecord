//
//  DropCell.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import DropDown

class DropCell: DropDownCell {

    @IBOutlet var colorCircles: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorCircles.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
