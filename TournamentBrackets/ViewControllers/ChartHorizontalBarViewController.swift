//
//  ChartHorizontalBarViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartHorizontalBarViewController : ChartBaseViewController {
 
    var viewModel : ChartsHorizontalBarViewModel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var chart: HorizontalBarChartView!
    
    override var pageIndex: Int {
        get {
            return viewModel.chartType.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelSubtitle.text = "\(viewModel.chartType)"
        setup()        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()
    }
    
    func setData() {
        viewModel.loadData()
        
        var yVals = [BarChartDataEntry]()
        for (i, y) in viewModel.yAxis.enumerate() {
            yVals.append(BarChartDataEntry(value: y, xIndex: i))
        }
        let dataset = BarChartDataSet(yVals: yVals, label: "\(viewModel.chartType)")
        let data = BarChartData(xVals: viewModel.xAxis, dataSets: [dataset])
        if viewModel.yAxisMaxValue > 0 {
            chart.leftAxis.axisMaxValue = Double(viewModel.yAxisMaxValue)
            chart.rightAxis.axisMaxValue = Double(viewModel.yAxisMaxValue)
        }
        let f = NSNumberFormatter()
        f.maximumFractionDigits = 0
        data.setValueFormatter(f)
        
        chart.data = data
        self.chart.animate(yAxisDuration: 0.75, easingOption: .EaseOutBack)
    }
    
    func setup() {
        let f = NSNumberFormatter()
        f.maximumFractionDigits = 0
        chart.leftYAxisRenderer.yAxis?.valueFormatter = f
        chart.rightYAxisRenderer.yAxis?.valueFormatter = f

        chart.descriptionText = ""
        chart.noDataTextDescription = "You need to provide data for the chart."
        chart.drawGridBackgroundEnabled = false
        chart.dragEnabled = true
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = false
        chart.xAxis.labelPosition = .Bottom
        chart.rightAxis.enabled = false        
        
        chart.drawBarShadowEnabled = false
        chart.drawValueAboveBarEnabled = true
        chart.maxVisibleValueCount = 60
        
        let xAxis = chart.xAxis
        xAxis.labelPosition = .Bottom;
        xAxis.labelFont = font9
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineWidth = 0.3
        
        let leftAxis = chart.leftAxis;
        leftAxis.labelFont = font9
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridLineWidth = 0.3
        leftAxis.resetCustomAxisMin()
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = font9
        rightAxis.drawAxisLineEnabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.resetCustomAxisMin()
        
        chart.legend.position = .BelowChartLeft
        chart.legend.form = .Square
        chart.legend.formSize = 8.0
        chart.legend.font = font11
        chart.legend.xEntrySpace = 4.0
    }
}