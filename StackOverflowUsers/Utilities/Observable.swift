//
//  Observable.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

final class Observable<T> {

    typealias Observer = (T) -> Void

    var value: T {
        didSet { observer?(value) }
    }

    private var observer: Observer?

    init(_ value: T) {
        self.value = value
    }

    /// Binds an observer and fires immediately with the current value.
    func observe(_ observer: @escaping Observer) {
        self.observer = observer
        observer(value)
    }
}
