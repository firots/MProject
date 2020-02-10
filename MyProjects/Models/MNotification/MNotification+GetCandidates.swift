//
//  MNotification+GetCandidates.swift
//  MyProjects
//
//  Created by Firot on 10.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

extension MNotification {
    func getCandidates() -> [NotificationCandidate] {
        
        var candidates = [NotificationCandidate]()
        
        guard let nextFireDate = self.nextFireDate else { return candidates }
        
        func createSubIDs() {
            if subID.isEmpty {
                for _ in 1...48 {
                    subID.append(UUID())
                }
            }
        }
        
        func cleanSubIDs() {
            for sid in subID {
                LocalNotifications.shared.delete(id: sid)
            }
            subID.removeAll()
        }
        
        func createSubCandidates() {
            createSubIDs()
            var repeatNextFireDate = nextFireDate
            for sid in subID {
                repeatNextFireDate.addHours(repeatPeriod)

                if isNextFireDateValid(for: repeatNextFireDate) {
                    let candidate = NotificationCandidate(id: sid.uuidString, title: wrappedTitle, message: wrappedMessage, date: repeatNextFireDate)
                    candidates.append(candidate)
                } else {
                    LocalNotifications.shared.delete(id: sid)
                }
            }
        }
        
        func createCandidate() {
            let candidate = NotificationCandidate(id: wrappedID.uuidString, title: wrappedTitle, message: wrappedMessage, date: nextFireDate)
            
            candidates.append(candidate)
        }
        
        if !isNextFireDateValid(for: nextFireDate) {
            self.nextFireDate = nil
            return candidates
        } else {
            createCandidate()
            if wrappedRepeatMode == .hour {
                createSubCandidates()
            } else {
                cleanSubIDs()
            }
            return candidates
        }
    }
}
