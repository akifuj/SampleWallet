//
//  CodableUTXO.swift
//  SampleWallet
//
//  Created by Akifumi Fujita on 2018/08/07.
//  Copyright © 2018年 Akifumi Fujita. All rights reserved.
//

import Foundation

struct CodableUTXO: Codable {
    let address: String
    let amount: Int
    let confirmations: Int
    let satoshis: Int
    let height: Int
    let scriptPubKey: String
    let txid: String
    let vout: Int
}
