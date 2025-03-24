//
//  NetworkService+Dependencies.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

private actor NetworkServiceKey: InjectionKey {
    static var currentValue: NetworkService = DefaultNetworkService()
}

extension InjectedValues {
    var networkService: NetworkService {
        get { Self.self[NetworkServiceKey.self] }
        set { Self.self[NetworkServiceKey.self] = newValue }
    }
}


