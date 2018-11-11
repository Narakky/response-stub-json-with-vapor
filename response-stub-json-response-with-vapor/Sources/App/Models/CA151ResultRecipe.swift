//
//  CA151ResultRecipe.swift
//  App
//
//  Created by Naraki on 11/9/18.
//

import Vapor

struct CA151ResultRecipe: Content {
    var title: String = ""
    var contentId: String = ""
    var thumbnailImage: String = ""
    var intakeCalorie: Double = 0.0
    var salt: Double = 0.0
    var protein: Double = 0.0
    var dietaryFiber: Double = 0.0
    var unreadFlag: Bool = false
    var publicationDate: String = ""
    /// オリジナルコンテンツ判定フラグ null = Fincレシピ以外
    var originalFlag: Bool?
    var carbohydrate: Double = 0.0
    var lipid: Double = 0.0
}
