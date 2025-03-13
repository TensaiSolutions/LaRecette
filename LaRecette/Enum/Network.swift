//
//  Network.swift
//  LaRecette
//
//  Created by philip sidell on 3/8/25.
//

enum NetworkError: Error {
    case badResponse
    case badStatus
    case badUrl
    case failedToDecodeResponse
    case invalidRequest
}
