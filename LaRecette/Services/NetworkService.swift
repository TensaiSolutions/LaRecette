//
//  NetworkService.swift
//  LaRecette
//
//  Created by philip sidell on 3/8/25.
//

import Foundation

public protocol NetworkService {
    func fetchData<T: Decodable>(fromUrl: String, session:URLSession) async throws -> T?
}


class DefaultNetworkService: NetworkService {
    func fetchData<T: Decodable>(fromUrl: String, session:URLSession) async throws -> T? {
        guard let downloadedData: T = try await DefaultNetworkService().downloadData(fromURL: fromUrl, session: session) else {return nil}

            return downloadedData
        }
    
    private func downloadData<T: Decodable>(fromURL: String, session:URLSession) async throws -> T? {
            do {
                guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
                let (data, response) = try await session.data(from: url)
                guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
                guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
                
                return decodedResponse
            } catch NetworkError.badUrl {
                print("There was an error creating the URL")
                throw NetworkError.badUrl
            } catch NetworkError.badResponse {
                print("Did not get a valid response")
                throw NetworkError.badResponse
            } catch NetworkError.badStatus {
                print("Did not get a 2xx status code from the response")
                throw NetworkError.badStatus
            } catch NetworkError.failedToDecodeResponse {
                print("Failed to decode response into the given type")
                throw NetworkError.failedToDecodeResponse
            } catch {
                print("An error occured downloading the data")
            }
            
            return nil
        }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject,
                                                       options: [.prettyPrinted]),
              let prettyJSON = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                  return nil
               }

        return prettyJSON
    }
}
