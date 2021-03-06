//
//  GamesListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 10/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

class GameListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelRound: UILabel!
    let bag = DisposeBag()
    var viewModel : GameListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableDataSource()
    }
    
    func configureTableDataSource() {
        
        labelRound.text = "ROUND \(viewModel.round)"
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        let color : UIColor = viewModel.isLoserBracket ? UIColor().loserBackgroundColor : UIColor.clearColor()
        tableView.backgroundColor = color
        
        viewModel.gamesInRound
            .asObservableArray()
            .bindTo(tableView.rx_itemsWithCellIdentifier("GameCell", cellType: GameCell.self)) {row, element, cell in
                cell.viewModel = self.viewModel.gameViewModels.filter{ (model) in model.index == element.index }.first
            }
            .addDisposableTo(bag)
    }
}

extension GameListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}