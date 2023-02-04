//
//  TemperaturaAPI.swift
//  ProjetoEM
//
//  Created by student on 06/10/22.
//  Copyright © 2022 Student. All rights reserved.
//

import Foundation

class TemperaturaAPI: Decodable {
    let _id: String
    let _rev: String
    let temperatura: String
    let time: Int
}
