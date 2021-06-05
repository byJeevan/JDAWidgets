//
//  BaseTableProtocol.swift
//  JDAWidgets
//
//  Created by Jeevan on 03/10/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation

/*
 * Protocols for the table rows.
 * Advantage: Generic entries for data source of Table.
 * Usage: Sequence of `TableSection` will be used as table data source.
 */
protocol RowRepresentable { }

protocol HeaderFooterRepresentable { }

struct TableSection {
    var header: HeaderFooterRepresentable?
    var rows: [RowRepresentable]?
    var footer: HeaderFooterRepresentable?
}
