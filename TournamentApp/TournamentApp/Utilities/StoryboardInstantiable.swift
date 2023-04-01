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
}

extension StoryboardInstantiable where Self: UIViewController {

  public static var storyboardFileName: String {
     "Main"
  }

  public static var storyboardIdentifier: String {
      return NSStringFromClass(Self.self).components(separatedBy: ".").last!
  }

  public static func instanceFromStoryboard(_ bundle: Bundle? = nil) -> Self {
    let fileName = storyboardFileName
    let sb = UIStoryboard(name: fileName, bundle: bundle)
    return sb.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! Self
  }
}
