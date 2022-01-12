//
//  CoHostTaskQueue.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/12.
//

import Foundation

class CoHostTaskQueue : NSObject {
    
    typealias coHostTask = (UserInfo) -> Void
    
    private var tasks: [coHostTask] = []
    private var parameters: [UserInfo] = []
    
    private var isExecuting: Bool = false
    
    func addTask(_ task: @escaping coHostTask, user: UserInfo) {
        tasks.append(task)
        parameters.append(user)
        if !isExecuting {
            execute()
        }
    }
        
    func finish() {
        isExecuting = false
        DispatchQueue.main.async {
            self.execute()
        }
    }
    
    func execute() {
        guard let task = tasks.first else { return }
        guard let user = parameters.first else { return }
        isExecuting = true
        tasks.remove(at: 0)
        parameters.remove(at: 0)
        DispatchQueue.main.async {
            task(user)
        }
    }
}
