//
//  DurationFormatter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation

// MARK: - DurationFormatter

protocol DurationFormatter {
    func format(milliseconds: Int) -> String
}

class DefaultDurationFormatter: DurationFormatter {
    /// Formats the duration in milliseconds into a string representation.
    /// - Parameter milliseconds: The duration in milliseconds.
    /// - Returns: The formatted duration string in the format "mm:ss".
    func format(milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
