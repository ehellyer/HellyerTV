//
//  Clock.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/29/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation

protocol ClockModelDelegate: AnyObject {
    func updateClockText(displayString: String)
}

class Clock {
    
    //MARK: Clock life cycle
    
    deinit {
        self.timer?.invalidate()
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }
    
    init(delegate: ClockModelDelegate?) {
        self.delegate = delegate
        let posix = Locale(identifier: "en_US_POSIX")
        let timeZone = TimeZone.current
        self.dateFormatter.locale = posix
        self.dateFormatter.setLocalizedDateFormatFromTemplate("EEE MMM d")
        self.dateFormatter.timeZone = timeZone
        self.timeFormatter.locale = posix
        self.timeFormatter.dateFormat = "h:mm a"
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.updateDisplayString()
        }
        self.updateDisplayString()
    }

    //MARK: Private API

    private var timer: Timer?
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    private let calendar = Calendar.current
    private weak var delegate: ClockModelDelegate?
    
    private func updateDisplayString() {
        let date = Date()
        let dateSuffix = self.daySuffix(date: date)
        let dateStr = self.dateFormatter.string(from: date)
        let timeStr = self.timeFormatter.string(from: date)
        self.delegate?.updateClockText(displayString: "\(dateStr)\(dateSuffix)  \(timeStr)")
    }

    private func daySuffix(date: Date) -> String {
        let dayOfMonth = self.calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
}
