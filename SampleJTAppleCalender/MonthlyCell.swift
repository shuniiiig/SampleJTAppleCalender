//
//  MonthlyCell.swift
//  SampleJTAppleCalender
//
//  Created by Shunsuke Igusa on 2019/10/31.
//  Copyright © 2019 Shunsuke Igusa. All rights reserved.
//

import UIKit
import JTAppleCalendar

final class MonthlyCell: JTAppleCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    var cache: Cache?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cache = nil
    }
    
    func configure(cellState: CellState) -> Cache {
        dayLabel.text = cellState.text
        self.cache = Cache(cellState)
        return cache!
    }
    
    func configure(cache: Cache) {
        self.cache = cache
        dayLabel.text = cache.cellState.text
    }
    
}


extension MonthlyCell {
    final class Cache {
        
        private(set) var cellState: CellState
        
        init(_ cellState: CellState) {
            self.cellState = cellState
        }
        
    }
}
