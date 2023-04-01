//
//  HapticsManager.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit
import Foundation


enum HapticVibrateType {
    case success
    case error
}

protocol HapticsManagerProvider {
    func vibrateForSelection()
    func vibrate(for type: HapticVibrateType)
}

final class HapticsManager: HapticsManagerProvider {
    
    init () {}
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: HapticVibrateType) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            let value = self.createFeedbackType(when: type)
            generator.notificationOccurred(value)
        }
    }
    
    private func createFeedbackType(when hapticVibrate: HapticVibrateType) -> UINotificationFeedbackGenerator.FeedbackType {
        switch hapticVibrate {
        case .success:
            return .success
        case .error:
            return .error
        }
    }
}
