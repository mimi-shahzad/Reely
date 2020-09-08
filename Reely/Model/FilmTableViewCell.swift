//
//  FilmTableViewCell.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/22/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class FilmTableViewCell: UITableViewCell {
    
    // MARK: - labels and image    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
        
}
