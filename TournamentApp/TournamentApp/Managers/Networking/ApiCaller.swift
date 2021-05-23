//
//  ApiCaller.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import Foundation
import Alamofire

final class ApiCaller {
    
    static let shared = ApiCaller()
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        return Session(configuration: configuration)
    }()
    private let headers: HTTPHeaders = [
        "x-tournament-id": "\(GlobalConstants.tournomentId)",
        "Accept": "application/json"
    ]
    
    private init () {}
    
    enum ApiError: LocalizedError {
        case faileedToGetData,
             runtimeError(message: String)
        
        var errorDescription: String? {
            switch self {
            case .faileedToGetData:
                return "Failed to get data."
            case .runtimeError(let message):
                return message
            }
        }
        
    }
    
    func getAllPlayerList(completion: @escaping (Result<[Player], Error>) -> Void) {
        self.sessionManager.request(APIUrl.shared.players, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion(.failure(ApiError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlayerListResponse.self, from: data)
                    if result.success {
                        completion(.success(result.data))
                    } else {
                        completion(.failure(ApiError.runtimeError(message: result.message)))
                    }
                    
                    
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                guard let data = response.data else {
                    completion(.failure(error))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(DefaultResponse.self, from: data)
                   
                    completion(.failure(ApiError.runtimeError(message: result.message)))
    
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deletePlayer(with id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        self.sessionManager.request(APIUrl.shared.players + "/\(id)", method: .delete, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion(.failure(ApiError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(DefaultResponse.self, from: data)
                    if result.success {
                        completion(.success(result.message))
                    } else {
                        completion(.failure(ApiError.runtimeError(message: result.message)))
                    }
                    
                    
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                guard let data = response.data else {
                    completion(.failure(error))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(DefaultResponse.self, from: data)
                   
                    completion(.failure(ApiError.runtimeError(message: result.message)))
    
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getDetailPlayer(with id: Int, completion: @escaping (Result<PlayerDetail, Error>) -> Void) {
        self.sessionManager.request(APIUrl.shared.players + "/\(id)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion(.failure(ApiError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlayerDetailResponse.self, from: data)
                    if result.success {
                        completion(.success(result.data))
                    } else {
                        completion(.failure(ApiError.runtimeError(message: result.message)))
                    }
                    
                    
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                guard let data = response.data else {
                    completion(.failure(error))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(DefaultResponse.self, from: data)
                   
                    completion(.failure(ApiError.runtimeError(message: result.message)))
    
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
}
