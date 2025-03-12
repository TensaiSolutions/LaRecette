//
//  Network.swift
//  LaRecette
//
//  Created by philip sidell on 3/8/25.
//

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}
