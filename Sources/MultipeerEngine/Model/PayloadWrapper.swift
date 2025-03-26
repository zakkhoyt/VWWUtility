//
//  PayloadWrapper.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 3/26/25.
//

public struct PayloadWrapper<C: Codable>: Codable, Sendable where C: Sendable {
    public init(
        payload: C,
        owner: String
    ) {
        let type = type(of: payload)
        self.payloadType = "\(type)"
        self.payload = payload
        self.owner = owner
    }
    
    public let payloadType: String
    public let payload: C
    public let owner: String

    enum CodingKeys: String, CodingKey {
        case payloadType
        case payload
        case owner
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payloadType, forKey: .payloadType)
        try container.encode(payload, forKey: .payload)
        try container.encode(owner, forKey: .owner)
    }
    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.owner = try container.decode(String.self, forKey: .owner)
//        let payloadType = try container.decode(String.self, forKey: .payloadType)
//        self.payloadType = payloadType
//        
//        switch payloadType {
//        case "User":
//            self.payload = try container.decode(User.self, forKey: .payload)
//        default:
//            break
//        }
//        
//        
//        
//        
//        //            self.status = try container.decode(String.self, forKey: .status)
//        //            self.message = try container.decode(String.self, forKey: .message)
//        //            self.payload = try container.decodeIfPresent([ServerRoutine].self, forKey: .payload) ?? []
//        //            self.sync = try container.decode(Int64.self, forKey: .sync)
//    }

}

