//
//  StoryboardInstantiable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

public protocol StoryboardInstantiable: AnyObject {
    associatedtype MyType
    static var storyboardFileName: String { get }
    static var storyboardIdentifier: String { get }
    static func instanceFromStoryboard(_ bundle: Bundle?) -> MyType
    static func instanceFromStoryboard(_ bundle: Bundle?, with creator: ((Foundation.NSCoder) -> UIViewController?)?) -> MyType
}

extension StoryboardInstantiable where Self: UIViewController {
    public static var storyboardFileName: String {
        "Main"
    }
    
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    public static func instanceFromStoryboard(_ bundle: Bundle? = nil) -> Self {
        let fileName = storyboardFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! Self
    }
    
    public static func instanceFromStoryboard(_ bundle: Bundle?, with creator: ((Foundation.NSCoder) -> UIViewController?)?) -> MyType {
        let fileName = storyboardFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        return storyboard.instantiateViewController(identifier: self.storyboardIdentifier, creator: creator) as! Self.MyType
    }
}

