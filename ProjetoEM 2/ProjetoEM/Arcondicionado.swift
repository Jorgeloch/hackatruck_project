//
//  Arcondicionado.swift
//  ProjetoEM
//
//  Created by Student on 30/09/22.
//  Copyright © 2022 Student. All rights reserved.
//

import Foundation

class Arcondicionado {
    var consumo: Double
    
    init(consumo: Double) {
        self.consumo = consumo
    }
}

class ArcondicionadoDAO {
   static func getListDAO() -> [Arcondicionado] {
        return [
            Arcondicionado(consumo: 30.0),
            Arcondicionado(consumo: 40.2),
        ]
    }
}
