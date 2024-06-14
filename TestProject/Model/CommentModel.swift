//
//  CommentModel.swift
//  TestProject
//
//  Created by Ahmad Shaheer on 14/06/2024.
//

import Foundation


struct CommentModel: Hashable {
    var id: String = UUID().uuidString
    let username: String
    let avatar: String
    let description: String
}
