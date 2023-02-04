//
//  ConsumoTableViewController.swift
//  ProjetoEM
//
//  Created by Student on 30/09/22.
//  Copyright © 2022 Student. All rights reserved.
//

import UIKit

class ArcondicionadoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func consumoButton(_ sender: Any) {
        
    }
    
    @IBAction func tempoDeUsoButton(_ sender: Any) {
        
    }
    
    @IBAction func temperaturaButton(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let novaView = segue.destination as? ArcondicionadoDetalhesViewController {
                
            novaView.tipo = segue.identifier

        }
    }

}
