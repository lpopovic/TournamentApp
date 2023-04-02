//
//  NetworkRoutable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

// MARK: - Routable

protocol NetworkRoutable {
    var path: ApiPath { get }
    var url: URL { get }
    var method: ApiHTTPMethod { get }
    var encoding: ApiParameterEncoding { get }
    var headers: ApiHTTPHeaders? { get }
    var parameters: ApiParameters? { get }
}

// MARK: - Default implementation

extension NetworkRoutable {
    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "internships-mobile.htec.co.rs"
        components.path = "\(path)"
        guard let url = components.url else {
            fatalError("Invalid url: internships-mobile.htec.co.rs\(path)")
        }
        print("URL: \(url)")
        return url
    }
    
    var method: ApiHTTPMethod {
        .get
    }
    var encoding: ApiParameterEncoding {
        .URLEncoding
    }

    var parameters: ApiParameters? {
        nil
    }
}
