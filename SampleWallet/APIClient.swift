//
//  APIClient.swift
//  SampleWallet
//
//  Created by Akifumi Fujita on 2018/08/07.
//  Copyright © 2018年 Akifumi Fujita. All rights reserved.
//

import Foundation
import BitcoinCashKit

class APIClient {
    
    private let apiEndPoint = "https://test-bch-insight.bitpay.com/api" // Mainnet: "https://bch-insight.bitpay.com/api"
    
    func getUnspentOutputs(withAddresses addresses: [String], completionHandler: @escaping ([UnspentOutput]) -> ()) {
        let paramAddrs = addresses.joined(separator: ",")
        let url = "\(apiEndPoint)/addrs/\(paramAddrs)/utxo"
        print("get unspent outputs url = \(url)")
        get(url: url, completion: { (data) in
            do {
                let utxos = try JSONDecoder().decode([UnspentOutput].self, from: data)
                completionHandler(utxos)
            } catch {
                print("Serialize Error")
            }
        })
    }
    
    func getTransaction(withAddresses address: String, completionHandler: @escaping ([CodableTx]) -> ()) {
        let url = "\(apiEndPoint)/txs"
        print("Transactions by Address: url = \(url)")
        get(url: url, completion: { (data) in
            do {
                let transactions = try JSONDecoder().decode(Transactions.self, from: data)
                completionHandler(transactions.transactions)
            } catch {
                print("Serialize Error")
            }
        }, queryItems: [URLQueryItem(name: "address", value: address)])
    }
    
    func get(url urlString: String, completion: @escaping (Data) -> (), queryItems: [URLQueryItem]? = nil) {
        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        guard let url = compnents?.url else {
            print("cannot create url")
            return
        }
        print("url \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("Unknown Error")
                }
                return
            }
            completion(data)
        }
        
        task.resume()
    }
    
    func post(url urlString: String, parameters: [String: Any], completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: urlString) else {
            print("cannot create url from url string")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("error: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("post error: \(error)")
            }
            completion(data)
        }
        task.resume()
    }
    
}
