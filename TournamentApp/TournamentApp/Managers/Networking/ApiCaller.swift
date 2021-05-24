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
        "Accept": "application/json",
    ]
    
    private init () {}
    
    enum ApiError: LocalizedError {
        case failedToGetData,
             runtimeError(message: String)
        
        var errorDescription: String? {
            switch self {
            case .failedToGetData:
                return "Failed to get data."
            case .runtimeError(let message):
                return message
            }
        }
        
    }
    
    enum ApiParameters: String {
        case firstName,
             lastName,
             description,
             points,
             dateOfBirth,
             isProfessional,
             profileImageUrl,
             limit,
             page
    }
    
    func getAllPlayerList(completion: @escaping (Result<[Player], Error>) -> Void) {
        self.sessionManager.request(APIUrl.shared.players, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(ApiError.failedToGetData))
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
    
    func getPlayerList(from page: Int, with limit: Int, completion: @escaping (Result<[Player], Error>) -> Void) {
        self.sessionManager.request(APIUrl.shared.players + "?\(ApiParameters.limit)=\(limit)&\(ApiParameters.page)=\(page)&", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(ApiError.failedToGetData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(PlayerListResponse.self, from: data)
                        
                        completion(.success(result.data))
                        
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
                        completion(.failure(ApiError.failedToGetData))
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
                        completion(.failure(ApiError.failedToGetData))
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
    
    func postCreatePlayer(firstName: String,
                          lastName: String,
                          description: String,
                          points: String,
                          dateOfBirth: String,
                          isProfessional: Int,
                          profileImageUrl: Data,
                          completion: @escaping (Result<DefaultResponse, Error>) -> Void) {
        var postHeader = headers
        postHeader.add(HTTPHeader(name: "Content-type", value: "multipart/form-data"))
        
        let params: [String: Any] = [
            ApiParameters.firstName.rawValue: firstName,
            ApiParameters.lastName.rawValue: lastName,
            ApiParameters.description.rawValue: description,
            ApiParameters.points.rawValue: points,
            ApiParameters.dateOfBirth.rawValue: dateOfBirth,
            ApiParameters.isProfessional.rawValue: isProfessional,
        ]
        
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(profileImageUrl, withName: ApiParameters.profileImageUrl.rawValue, fileName: "tmp.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                if let dataValue = "\(value)".data(using: .utf8) {
                    multipartFormData.append(dataValue, withName: key)
                }
                
            }
            
        }, to: APIUrl.shared.players+"/1270", usingThreshold: UInt64.init(), method: .post, headers: postHeader)
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            
            switch response.result {
            case .success(_ ):
                guard let data = response.data else {
                    completion(.failure(ApiError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(DefaultResponse.self, from: data)
                    
                    completion(.success(result))
                    
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
    
    func putDetailPlayer(with id: Int,
                         paramsToUpdate: [String: Any],
                         profileImageUrl: Data?,
                         completion: @escaping (Result<DefaultResponse, Error>) -> Void) {
        var queryParam: String = ""
        
        for (key, value) in paramsToUpdate {
            queryParam = queryParam + "&\(key)=\(value)"
        }
        
        self.sessionManager.request(APIUrl.shared.players + "/\(id)?\(queryParam)", method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(ApiError.failedToGetData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(DefaultResponse.self, from: data)
                        
                        completion(.success(result))
                        
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
