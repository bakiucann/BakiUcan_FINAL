//
//  DurationFormatter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation

protocol DurationFormatter {
    func format(milliseconds: Int) -> String
}

class DefaultDurationFormatter: DurationFormatter {
    func format(milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
