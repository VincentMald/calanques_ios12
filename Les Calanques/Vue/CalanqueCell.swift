//
//  CalanqueCell.swift
//  Les Calanques
//
//  Created by Vincent Maldonado on 02/05/2019.
//  Copyright © 2019 Vincent Maldonado. All rights reserved.
//

import UIKit

class CalanqueCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var calanqueIV: ImageRonde!
    
    var calanque: Calanque!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(_ calanque: Calanque){
        self.calanque = calanque
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = UIColor.lightGray
        nomLabel.text = self.calanque.nom
        calanqueIV.image = self.calanque.image
    }

}
