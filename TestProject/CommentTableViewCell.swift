//
//  CommentTableViewCell.swift
//  TestProject
//
//  Created by Ahmad Shaheer on 13/06/2024.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = 29
        commentLbl.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateData(model: CommentModel) {
        avatarImageView.backgroundColor = .black
        usernameLbl.text = model.username
        commentLbl.text = model.description
    }
    
}
