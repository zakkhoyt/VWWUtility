//
//  OptionalDescription.swift
//
//
//  Created by Zakk Hoyt on 6/7/24.
//

extension Optional where Wrapped: TextOutputStreamable {
    public var naString: String {
        optionalString
    }
    
    public var optionalString: String {
        switch self {
        case .none:
            "<n/a>"
        case .some(let wrapped):
            String(describing: wrapped)
        }
    }
}
