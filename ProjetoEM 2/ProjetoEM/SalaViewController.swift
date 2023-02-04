//
//  SalaViewController.swift
//  ProjetoEM
//
//  Created by Student on 30/09/22.
//  Copyright © 2022 Student. All rights reserved.
//

import UIKit

class SalaViewController: UIViewController {

    
    @IBOutlet weak var salaLabel: UILabel!
    var sala: Sala?
    override func viewDidLoad() {
        super.viewDidLoad()

        salaLabel.text = sala?.nome
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhes" {
            if let novaView = segue.destination as? DetalhesViewController {
                novaView.sala = self.sala
            }
        }
    }

}
