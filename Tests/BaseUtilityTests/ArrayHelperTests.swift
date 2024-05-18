import BaseUtility
import XCTest

final class ArrayHelperTests: XCTestCase {
    func testReflectPropertiesOnClass() throws {
        let a = "a"
        let b = "b"
        let c = "c"
        let i = 123
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
    
    func testListDescriptions() {
        struct Thing: CustomStringConvertible {
            let name: String
            let age: Int
            
            var description: String {
                "\(name) \(age)"
            }
        }
        let str: String = "String"
        let point = CGPoint(x: 1, y: 1)
        let thing = Thing(name: "me", age: 10)
        let dict: [String: any CustomStringConvertible] = [
            "a": "A",
            "b": thing
        ]
        dump(dict)
        let varD = dict.listDescription()
        dump(varD)
        ()
        #warning("FIXME: zakkhoyt - use testing")
    }
}


//extension Array where Element: CustomStringConvertible {
//    public func listDescription(
//        separator: String = ", ",
//        endcaps: (String, String) = ("[", "]")
//    ) -> String {
//        let insert = separator == "\n" ? "\n" : ""
//        return "\(endcaps.0)\(insert)\(map { $0.description }.joined(separator: separator))\(insert)\(endcaps.1)"
//    }
//    
//    /// Converts any `[CustomStringConvertible]` to a comma delimited list (`String` ).
//    public var listDescription: String {
//        map { $0.description }.listDescription
//    }
//}
//
//extension Array where Element: CustomDebugStringConvertible {
//    /// Converts any `[CustomDebugStringConvertible]` to a comma delimited list (`String` ).
//    public var listDescription: String {
//        map { $0.debugDescription }.listDescription
//    }
//}
//
//extension [String: any CustomStringConvertible] {
//    public var dictDescription: String {
//        //        compactMapValues { $0 }
//        compactMapValues {
//            //guard let value = $0 else { return "<nil>" }
//            return String(describing: $0)
//        }
//        .map {
//            [
//                $0.key, $0.value
//            ].joined(separator: ": ")
//        }
//        .listDescription
////        .sorted()
////        .joined(separator: ", ")
//    }
//    
//    
//    public func listDescription(
//        separator: String = ", ",
//        endcaps: (String, String) = ("[", "]")
//    ) -> String {
//        //        compactMapValues { $0 }
//        compactMapValues {
//            //guard let value = $0 else { return "<nil>" }
//            return String(describing: $0)
//        }
//        .map {
//            [
//                $0.key, $0.value
//            ].joined(separator: ": ")
//        }.listDescription(separator: separator, endcaps: endcaps)
//        
//    }
//}
//
