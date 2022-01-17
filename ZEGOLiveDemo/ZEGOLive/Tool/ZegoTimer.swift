//
//  TimerUtil.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/20.
//

import Foundation

class ZegoTimer : NSObject {
    
    typealias eventHandler = () -> Void
    
    private let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    // the default interval is 1s
    private var interval: Int = 1000
    
    private var isSuspend: Bool = true
    
    private var startNow: Bool = true
    
    init(_ interval: Int, startNow: Bool = true) {
        if interval > 0 {
            self.interval = interval
            self.startNow = startNow
        }
    }
    
    func setEventHandler(handler: eventHandler?) {
        var dispatchTime: DispatchTime = .now()
        if !startNow {
            dispatchTime = .now() + .milliseconds(self.interval)
        }
        timer.schedule(deadline: dispatchTime, repeating: .milliseconds(self.interval))
        timer.setEventHandler {
            guard let handler = handler else {
                return
            }
            DispatchQueue.main.async {
                handler()
            }
        }
    }
    
    func start() {
        if isSuspend {
            timer.resume()
        }
        isSuspend = false
    }
    
    func stop() {
        if isSuspend {
            return
        }
        isSuspend = true
        timer.suspend()
    }
    
    deinit {
        if isSuspend {
            timer.resume()
        }
        timer.cancel()
    }
}
