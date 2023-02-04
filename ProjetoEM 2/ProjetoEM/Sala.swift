//
//  Sala.swift
//  ProjetoEM
//
//  Created by Student on 30/09/22.
//  Copyright © 2022 Student. All rights reserved.
//

import Foundation

class Sala {
    var nome: String
    init(nome:String) {
        self.nome = nome
    }
}

class SalaDAO {
    static func getList() -> [Sala] {
        return [
            Sala(nome: "arcondicionado 1")
        ]
    }
}
