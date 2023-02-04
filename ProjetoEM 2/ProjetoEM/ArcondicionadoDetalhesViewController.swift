//
//  ArcondicionadoDetalhesViewController.swift
//  ProjetoEM
//
//  Created by Student on 03/10/22.
//  Copyright © 2022 Student. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class ArcondicionadoDetalhesViewController: UIViewController, ChartViewDelegate {
    var correntes = [CorrenteAPI]()
    var temperaturas = [TemperaturaAPI]()
    var tipo: String?
    @IBOutlet weak var detalhesLabel: UILabel!
    
    var yValues: [ChartDataEntry] = [
        
        ChartDataEntry(x:0.0, y:0),
        ChartDataEntry(x:1.0, y:1)
    
    ]

    lazy var lineChartView: LineChartView = {

        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        //chartView.xAxis.labelPosition = cha
        chartView.backgroundColor = .white
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 10)
        yAxis.setLabelCount(6, force: false)
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 10)
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(6, force: false)
        xAxis.axisLineColor = .white
        //xAxis.axisLineColor = .systemBlue
        //chartView.xAxis.labelPosition = .bottom 
        chartView.animate(xAxisDuration: 5)
        chartView.animate(yAxisDuration: 5)
        /*
        if (interval <= 0)
        {
            xAxis.granularity = 1.0 / 24.0
        } else {
            xAxis.granularity = 1.0 / 24.0 * Double(interval)
        }*/
        
        return chartView
        
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self

        detalhesLabel.text = self.tipo!
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        print(self.tipo!)
        if(self.tipo! == "corrente"){
            downloadCorrenteJSON{ [self] in
                let sorted = self.correntes.sorted{
                    $0.time < $1.time
                }
                var values:[ChartDataEntry] = []
                var index = 1.0
                for a in sorted{
                    print(a.corrente)
                    values.append(ChartDataEntry(x: index, y: Double(a.corrente) ?? 0.0))
                    index += 1
                }
                setData(titulo: "Corrente (A)", values: values)

            }
        }else if(self.tipo! == "potencia"){
            downloadCorrenteJSON{ [self] in
                let sorted = self.correntes.sorted{
                    $0.time < $1.time
                }
                var values:[ChartDataEntry] = []
                var index = 1.0
                for a in sorted{
                    print(a.potencia)
                    values.append(ChartDataEntry(x: index, y: Double(a.potencia) ?? 0.0))
                    index += 1
                }
                setData(titulo: "Potencia (W)", values: values)
            }
        }else if(self.tipo! == "temperatura"){
            downloadTemperaturaJSON{ [self] in
                let sorted = self.temperaturas.sorted{
                    $0.time < $1.time
                }
                var values:[ChartDataEntry] = []
                var index = 1.0
                for a in sorted{
                    print(a.temperatura)
                    values.append(ChartDataEntry(x: index, y: Double(a.temperatura) ?? 0.0))
                    index += 1
                }
                setData(titulo: "Temperatura (ºC)", values: values)
            }
        }

    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(titulo: String, values: [ChartDataEntry]) {
        
        let set1 = LineChartDataSet(entries: values, label: titulo)
        
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.blue)
        set1.fill = Fill(color: .blue)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemBlue
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
        
    }
    
    func downloadCorrenteJSON(completed: @escaping () -> ()){
        let url = URL(string: "http://192.168.128.34:1880/dadosCorrente")
        
        URLSession.shared.dataTask(with: url!) {data, response, err in
            
            print(data!)
   
            
            if err == nil {
                do {
                    self.correntes = try JSONDecoder().decode([CorrenteAPI].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    print("error fetching data from api")
                }
            }
        }.resume()
    }
    
    func downloadTemperaturaJSON(completed: @escaping () -> ()){
        let url = URL(string: "http://192.168.128.34:1880/dadosTemperatura")

        URLSession.shared.dataTask(with: url!) {data, response, err in
            if err == nil {
                do {
                    self.temperaturas = try JSONDecoder().decode([TemperaturaAPI].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    print("error fetching data from api")
                }
            }
        }.resume()
    }
}


