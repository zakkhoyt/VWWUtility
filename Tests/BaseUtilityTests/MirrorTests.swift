import XCTest
import BaseUtility

final class MirrorTests: XCTestCase {
    
    private func reflect<T>(
        propertiesOfType propertiesType: T.Type,
        withNames propertyNames: [String],
        on instance: Any
    ) {
        let instances = Mirror.reflectInstances(of: instance, matchingType: propertiesType)
        dump(instances)
        let propertyTuples = Mirror.reflectProperties(of: instance, matchingType: propertiesType)
        XCTAssert(propertyTuples.count == propertyNames.count, "Expected \(propertyNames.count) properties of type \(propertiesType)")
        let propertyNames = propertyTuples.map { $0.0 }
        propertyNames.forEach { propertyName in
            XCTAssert(propertyNames.contains(where: { $0 == propertyName}), "Expected to find property named '\(propertyName)'")
        }
    }

    func testReflectPropertiesOnClass() throws {
        let classInstance = ClassToMirror()

        reflect(
            propertiesOfType: String.self,
            withNames: ["name", "about"],
            on: classInstance
        )
        
        reflect(
            propertiesOfType: Int.self,
            withNames: ["count"],
            on: classInstance
        )

        reflect(
            propertiesOfType: UUID.self,
            withNames: ["uuid"],
            on: classInstance
        )

        reflect(
            propertiesOfType: Date.self,
            withNames: ["date"],
            on: classInstance
        )
    }
    
    func testReflectPropertiesOnStruct() throws {
        let structInstance = StructToMirror()

        reflect(
            propertiesOfType: String.self,
            withNames: ["name", "about"],
            on: structInstance
        )
        
        reflect(
            propertiesOfType: Int.self,
            withNames: ["count"],
            on: structInstance
        )

        reflect(
            propertiesOfType: UUID.self,
            withNames: ["uuid"],
            on: structInstance
        )

        reflect(
            propertiesOfType: Date.self,
            withNames: ["date"],
            on: structInstance
        )
    }
}

private protocol ProtocolToMirror {
    var name: String { get }
    var about: String { get }
    var count: Int { get }
    var uuid: UUID { get }
    var date: Date { get }
}

private class ClassToMirror: ProtocolToMirror {
    var name: String
    var about: String
    var count: Int
    var uuid: UUID
    var date: Date
    
    init(
        name: String = "myName",
        about: String = "myAbout",
        count: Int = 33,
        uuid: UUID = UUID(),
        date: Date = Date()
    ) {
        self.name = name
        self.about = about
        self.count = count
        self.uuid = uuid
        self.date = date
    }
}

private struct StructToMirror: ProtocolToMirror {
    var name: String
    var about: String
    var count: Int
    var uuid: UUID
    var date: Date
    
    init(
        name: String = "myName",
        about: String = "myAbout",
        count: Int = 33,
        uuid: UUID = UUID(),
        date: Date = Date()
    ) {
        self.name = name
        self.about = about
        self.count = count
        self.uuid = uuid
        self.date = date
    }
}

private enum EnumToMirror: ProtocolToMirror {
    case a
    case b
    
    var name: String { "myName" }
    var about: String { "myAbout" }
    var count: Int { 33 }
    var uuid: UUID { UUID() }
    var date: Date { Date() }
}
