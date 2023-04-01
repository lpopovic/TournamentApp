//
//  ErrorAlert.swift
//  HRManager
//
//  Created by Mladen Stojanovic on 1.3.21..
//  Copyright © 2021 HTEC. All rights reserved.
//

import UIKit

struct ErrorAlert: Alert {
	var title: String? = "ERROR"
	var message: String?
	var completion: NoArgsClosure?
	
	init(message: String?, completion: NoArgsClosure? = nil) {
		self.completion = completion
		self.message = message
	}
	
	func getActions() -> [UIAlertAction] {
		[
			UIAlertAction(
                title: "OK",
                style: .default
            ) { _ in
				self.completion?()
			}
		]
	}
}
