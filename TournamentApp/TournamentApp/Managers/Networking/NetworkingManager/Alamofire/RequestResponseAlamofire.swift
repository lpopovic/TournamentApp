//
//  RequestResponseAlamofire.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation
import Alamofire

extension DataRequest {
    private func response(from responseData: AFDataResponse<Any>) -> ResultBasic {
      
        guard case .success(_) = responseData.result else {
            return .failure(error(from: responseData))
        }
        if let error = responseData.error {
            return .failure(NetworkError.runtimeError(message: error.localizedDescription))
        }
        guard let data = responseData.data else {
            return .failure(NetworkError.general)
        }
        guard let responseObject = try? JSONDecoder().decode(DefaultResponse.self, from: data)
        else {
            return .failure(NetworkError.mapping)
        }
        if responseObject.success {
            return .success
        } else {
            return .failure(NetworkError.runtimeError(message: responseObject.message))
        }
    }
    
    private func responseObject<T: Decodable>(from responseData: AFDataResponse<Any>) -> Result<T, NetworkError> {
        guard let data = responseData.data else {
            return .failure(.general)
        }
        guard case .success(_) = responseData.result else {
            return .failure(error(from: responseData))
        }
        if let error = responseData.error {
            return .failure(.runtimeError(message: error.localizedDescription))
        }
        guard let responseObject = try? JSONDecoder().decode(DataResponse<T>.self, from: data)
        else {
            return .failure(.mapping)
        }
        if responseObject.success {
            return .success(responseObject.data)
        } else {
            return .failure(.runtimeError(message: responseObject.message))
        }
    }

    private func responseArray<T: Decodable>(from responseData: AFDataResponse<Any>) -> Result<[T], NetworkError> {
        guard case .success(_) = responseData.result else {
            return .failure(error(from: responseData))
        }
        if let error = responseData.error {
            return .failure(.runtimeError(message: error.localizedDescription))
        }
        guard let data = responseData.data else {
            return .failure(.general)
        }
        guard let responseObject = try? JSONDecoder().decode(DataResponse<[T]>.self, from: data)
        else {
            return .failure(.mapping)
        }
        if responseObject.success {
            return .success(responseObject.data)
        } else {
            return .failure(.runtimeError(message: responseObject.message))
        }
    }

    private func error(from response: AFDataResponse<Any>) -> NetworkError {
        guard let data = response.data else {
            if let error = response.error {
                return .runtimeError(message: error.localizedDescription)
            } else {
                return .failedToGetData
            }
        }
        do {
            let result = try JSONDecoder().decode(DefaultResponse.self, from: data)
            return .runtimeError(message: result.message)
        } catch let error {
            return .runtimeError(message: error.localizedDescription)
        }
    }
}

extension DataRequest: RequestResponseProvider {
    func response(completion: @escaping (ResultBasic) -> ()) {
        responseJSON { [weak self] response in
            guard let self else { return }
            completion(self.response(from: response))
        }
    }
    
    func responseObject<T: Decodable>(completion: @escaping (Result<T, NetworkError>) -> ()) {
        responseJSON { [weak self] response in
            guard let self else { return }
            completion(self.responseObject(from: response))
        }
    }
    
    func responseArray<T: Decodable>(completion: @escaping (Result<[T], NetworkError>) -> ()) {
        responseJSON { [weak self] response in
            guard let self else { return }
            completion(self.responseArray(from: response))
        }
    }
}
