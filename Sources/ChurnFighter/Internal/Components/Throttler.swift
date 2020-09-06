//
//  Throttler.swift
//  ChurnFighter
//


import Foundation

final class Throttler {

    private let queue: DispatchQueue = DispatchQueue.main

    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private var maxInterval: Int

    init(seconds: Int) {
        self.maxInterval = seconds
    }

    func throttle(block: @escaping () -> ()) {
        
        job.cancel()
        job = DispatchWorkItem(){ [weak self] in
            self?.previousRun = Date()
            block()
        }
        let delay = maxInterval
        queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
    }
}

private extension Date {
    
    static func second(from referenceDate: Date) -> Int {
        
        return Int(Date().timeIntervalSince(referenceDate).rounded())
    }
}
