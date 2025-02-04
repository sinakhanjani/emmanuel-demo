//
//  Dispose.swift
//  Nerkh
//
//  Created by Sina khanjani on 1/9/1399 AP.
//  Copyright © 1399 Sina Khanjani. All rights reserved.
//

import Foundation

public class DisposeBag {
    private var disposables = [Disposable]()
    
    func insert(disposable : Disposable) {
        disposables.append(disposable)
    }
    
    func dispose() {
        for disposable in disposables {
            disposable.dispose()
        }
        disposables.removeAll(keepingCapacity: false)
    }
    
    deinit {
        dispose()
    }
}

public class Disposable {
    func dispose() {
        
    }
}

extension Disposable {
    func disposed(by disposeBag : DisposeBag) {
        disposeBag.insert(disposable: self)
    }
}
