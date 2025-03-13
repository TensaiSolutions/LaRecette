//
//  NetworkService+Dependencies.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

private struct NetworkServiceKey: InjectionKey {
    static var currentValue: NetworkService = DefaultNetworkService()
}

extension InjectedValues {
    var networkService: NetworkService {
        get { Self[NetworkServiceKey.self] }
        set { Self[NetworkServiceKey.self] = newValue }
    }
}


