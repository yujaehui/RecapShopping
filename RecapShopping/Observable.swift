//
//  Observable.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 2/23/24.
//

import Foundation

class Observable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.listener = closure
    }
}
