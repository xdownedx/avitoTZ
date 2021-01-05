//
//  modelData.swift
//  avitoTZ
//
//  Created by Максим Палёхин on 05.01.2021.
//

import Foundation

struct data:Decodable {
    var status: String
    var result: result
}
struct result:Decodable {
    var title: String
    var actionTitle: String
    var selectedActionTitle: String
    var list: Array<list>
}
struct list:Decodable {
    var id: String
    var title: String
    var description: String?
    var icon: [String: String]
    var price: String
    var isSelected: Bool
}

