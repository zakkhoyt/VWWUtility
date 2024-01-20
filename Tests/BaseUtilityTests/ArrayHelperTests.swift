import BaseUtility
import XCTest

final class ArrayHelperTests: XCTestCase {
    func testReflectPropertiesOnClass() throws {
        
        let a: String = "a"
        let b: String = "b"
        let c: String = "c"
        let i: Int = 123
        let oi: Int? = 234
        let o: String? = nil
        
        
        let vd: [String: String?] = [
            "a": a,
            "b": b,
            "c": c,
//            "i": if let i { "\(i)" } else { nil },
//            "oi": if let oi { "\(oi)" } else { nil },
            "o": o
        ]
        let d = vd.varDescription
        print(d)
        dump(d)
        print("")
        
        
        
        let sd = vd.sorted { // (key: String, value: String?), (key: String, value: String?) in
            $0.key > $1.key
        }.description
        print(sd)
        print(sd.description)
        print(sd.debugDescription)
        dump(sd)
        print("")
        
        
        let dd = vd.compactMapValues { // String? in
            guard let value = $0 else { return "<nil>" }
            return value
        }
        print(dd)
        print(dd.description)
        print(dd.debugDescription)
        dump(dd)
        print("")
        
        
        let dd2 = vd.compactMapValues { // String? in
            guard let value = $0 else { return "<nil>" }
            return value
        }
//        let ddd: String = dd2.
        let keys = vd.keys.sorted()
        let ddd = keys.map {
            guard let value = dd2[$0] else { return "<NIL>" }
            return #""\#($0)": "\#(value)""#
        }
        
        
        
        
        print(ddd)
//        print(ddd.description)
//        print(ddd.debugDescription)
//        dump(ddd)
        print("")
        
        
        
        
    }
    
}
