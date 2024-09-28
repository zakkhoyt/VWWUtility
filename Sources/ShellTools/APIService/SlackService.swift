import Foundation

// {

//   "members" : [
//     {
//       "color" : "757575",
//       "deleted" : false,
//       "id" : "USLACKBOT",
//       "is_admin" : false,
//       "is_app_user" : false,
//       "is_bot" : false,
//       "is_email_confirmed" : false,
//       "is_owner" : false,
//       "is_primary_owner" : false,
//       "is_restricted" : false,
//       "is_ultra_restricted" : false,
//       "name" : "slackbot",
//       "profile" : {
//         "always_active" : true,
//         "avatar_hash" : "sv41d8cd98f0",
//         "display_name" : "Slackbot",
//         "display_name_normalized" : "Slackbot",
//         "fields" : {

//         },
//         "first_name" : "slackbot",
//         "image_24" : "https:\/\/a.slack-edge.com\/80588\/img\/slackbot_24.png",
//         "image_32" : "https:\/\/a.slack-edge.com\/80588\/img\/slackbot_32.png",
//         "image_48" : "https:\/\/a.slack-edge.com\/80588\/img\/slackbot_48.png",
//         "image_72" : "https:\/\/a.slack-edge.com\/80588\/img\/slackbot_72.png",
//         "image_192" : "https:\/\/a.slack-edge.com\/80588\/marketing\/img\/avatars\/slackbot\/avatar-slackbot.png",
//         "image_512" : "https:\/\/a.slack-edge.com\/80588\/img\/slackbot_512.png",
//         "last_name" : "",
//         "phone" : "",
//         "real_name" : "Slackbot",
//         "real_name_normalized" : "Slackbot",
//         "skype" : "",
//         "status_emoji" : "",
//         "status_emoji_display_info" : [

//         ],
//         "status_expiration" : 0,
//         "status_text" : "",
//         "status_text_canonical" : "",
//         "team" : "T03TR3R94",
//         "title" : ""
//       },
//       "real_name" : "Slackbot",
//       "team_id" : "T03TR3R94",
//       "tz" : "America\/Los_Angeles",
//       "tz_label" : "Pacific Daylight Time",
//       "tz_offset" : -25200,
//       "updated" : 0,
//       "who_can_share_contact_card" : "EVERYONE"
//     }
//   ],
//   "cache_ts" : 1682732009,
//   "offset" : "U03TPFDLD",
//   "ok" : true,
//   "response_metadata" : {
//     "next_cursor" : "dXNlcjpVMDNUUEZETEQ="
//   }
// }

public protocol SlackAPIResponse: Decodable {
    var ok: Bool { get }
}

// https://app.quicktype.io/
public struct SlackModel: Codable {
    public struct ErrorResponse: SlackAPIResponse, Codable {
        public let error: String
        public let ok: Bool
    }

    public struct ChannelResponse: SlackAPIResponse, Codable {
        public let channel: Channel
        public let ok: Bool
    }

    public struct UsersResponse: SlackAPIResponse, Codable {
        public let users: [User]
        public let ok: Bool
        public let cacheTimestamp: UInt
        
        enum CodingKeys: String, CodingKey {
            case users = "members"
            case ok
            case cacheTimestamp = "cache_ts"
        }
    }

    public struct ChannelsResponse: SlackAPIResponse, Codable {
        public let channels: [Channel]
        public let ok: Bool
        public let responseMetadata: ResponseMetadata

        enum CodingKeys: String, CodingKey {
            case channels
            case ok
            case responseMetadata = "response_metadata"
        }
    }

    // public struct ChannelsResponse: SlackAPIResponse, Codable {
    //     public let channels: [Channel]
    //     public let ok: Bool
    //     public let responseMetadata: ResponseMetadata
    //     "cache_ts" : 1682732009,
    //     "offset" : "U03TPFDLD",

    //     enum CodingKeys: String, CodingKey {
    //         case channels
    //         case ok
    //         case responseMetadata = "response_metadata"
    //     }
    // }

    public struct ResponseMetadata: Codable {
        public let nextCursor: String
        
        enum CodingKeys: String, CodingKey {
            case nextCursor = "next_cursor"
        }
    }

    public struct Welcome: Codable {
        public let channel: Channel
        public let ok: Bool
    }

    public struct Channel: Codable {
        public let contextTeamID: String
        public let created: Int
        public let creator, id: String
        public let isArchived, isChannel, isEXTShared, isGeneral: Bool
        public let isGroup, isIM, isMember, isMpim: Bool
        public let isOrgShared, isPendingEXTShared, isPrivate, isShared: Bool
        public let name, nameNormalized: String
        // let parentConversation: JSONNull?
        // let pendingConnectedTeamIDS, pendingShared, previousNames: [JSONAny]
        public let purpose: Purpose
        public let sharedTeamIDS: [String]?
        public let topic: Purpose
        public let unlinked, updated: Int

        enum CodingKeys: String, CodingKey {
            case contextTeamID = "context_team_id"
            case created, creator, id
            case isArchived = "is_archived"
            case isChannel = "is_channel"
            case isEXTShared = "is_ext_shared"
            case isGeneral = "is_general"
            case isGroup = "is_group"
            case isIM = "is_im"
            case isMember = "is_member"
            case isMpim = "is_mpim"
            case isOrgShared = "is_org_shared"
            case isPendingEXTShared = "is_pending_ext_shared"
            case isPrivate = "is_private"
            case isShared = "is_shared"
            case name
            case nameNormalized = "name_normalized"
            case purpose
            case sharedTeamIDS = "shared_team_ids"
            case topic, unlinked, updated
        }
    }

    public struct Purpose: Codable {
        public let creator: String
        public let lastSet: Int
        public let value: String

        enum CodingKeys: String, CodingKey {
            case creator
            case lastSet = "last_set"
            case value
        }
    }

    // MARK: - Welcome

    public struct User: Codable {
        public let color: String?
        public let deleted: Bool?
        public let id: String
        public let isAdmin: Bool?
        public let isAppUser: Bool?
        public let isBot: Bool?
        public let isEmailConfirmed: Bool?
        public let isOwner: Bool?
        public let isPrimaryOwner: Bool?
        public let isRestricted: Bool?
        public let isUltraRestricted: Bool?
        public let isWorkflowBot: Bool?
        public let name: String?
        public let profile: Profile?
        public let realName: String?
        public let teamID: String?
        public let tz: String?
        public let tzLabel: String?
//        public let tzOffset, updated: Int
//        public let whoCanShareContactCard: String

        enum CodingKeys: String, CodingKey {
            case color
            case deleted
            case id
            case isAdmin = "is_admin"
            case isAppUser = "is_app_user"
            case isBot = "is_bot"
            case isEmailConfirmed = "is_email_confirmed"
            case isOwner = "is_owner"
            case isPrimaryOwner = "is_primary_owner"
            case isRestricted = "is_restricted"
            case isUltraRestricted = "is_ultra_restricted"
            case isWorkflowBot = "is_workflow_bot"
            case name, profile
            case realName = "real_name"
            case teamID = "team_id"
            case tz
            case tzLabel = "tz_label"
//            case tzOffset = "tz_offset"
//            case updated
//            case whoCanShareContactCard = "who_can_share_contact_card"
        }
    }

    // MARK: - Profile

    public struct Profile: Codable {
        public let alwaysActive: Bool?
        public let apiAppID: String?
        public let avatarHash: String?
        public let botID: String?
        public let displayName: String?
        public let displayNameNormalized: String?
        // public let fields: JSONNull?
        public let firstName: String?
        public let image24, image32, image48, image72: String?
        public let image192, image512: String?
        public let lastName: String?
        public let phone: String?
        public let realName: String?
        public let realNameNormalized: String?
        public let skype: String?
        public let statusEmoji: String?
        // public let statusEmojiDisplayInfo: [JSONAny]
        public let statusExpiration: Int?
        public let statusText: String?
        public let statusTextCanonical: String?
        public let team: String?
        public let title: String?

        enum CodingKeys: String, CodingKey {
            case alwaysActive = "always_active"
            case apiAppID = "api_app_id"
            case avatarHash = "avatar_hash"
            case botID = "bot_id"
            case displayName = "display_name"
            case displayNameNormalized = "display_name_normalized"
            // case fields
            case firstName = "first_name"
            case image24 = "image_24"
            case image32 = "image_32"
            case image48 = "image_48"
            case image72 = "image_72"
            case image192 = "image_192"
            case image512 = "image_512"
            case lastName = "last_name"
            case phone
            case realName = "real_name"
            case realNameNormalized = "real_name_normalized"
            case skype
            case statusEmoji = "status_emoji"
            // case statusEmojiDisplayInfo = "status_emoji_display_info"
            case statusExpiration = "status_expiration"
            case statusText = "status_text"
            case statusTextCanonical = "status_text_canonical"
            case team, title
        }
    }
}

public actor SlackService {
    public enum Error: Swift.Error {
        case usersAlreadyInChannel
        case apiResponseError(message: String)
        case rateLimited
    }

    public init() {}

    public func listUsers(
        limit: Int? = nil,
        botToken: String
    ) async throws -> [SlackModel.User] {
//    ) async throws {
        var p: [String: Any] = [:]
        if let limit {
            p["limit"] = limit
        }
//            "limit": limit
//        ].compactMapValues {
//            $0
//        }
//
//        let q = p
//
        // https://api.slack.com/methods/users.list
        let (data, _) = try await APIService().send(
            url: URL(string: "https://slack.com/api/users.list")!,
            httpMethod: .get,
            headers: [
                "Content-type": "application/json; charset=utf-8",
                "Authorization": "Bearer \(botToken)"
            ],
            parameters: p
        )
        let jsonString = String(data: data, encoding: .utf8) ?? "<n/a>"

        // See if payload is an error type
        try parseError(data: data)

        do {
            let usersResponse = try JSONDecoder().decode(SlackModel.UsersResponse.self, from: data)
            return usersResponse.users
        } catch let error as DecodingError {
            assertionFailure(error.debugDescription)
            logger.debug("Failed to parse payload for listUsers:\n\(error.debugDescription)")
            logger.debug("\(jsonString)")
            throw error
        } catch {
            logger.debug("Failed to parse payload for listUsers:\n\(error.localizedDescription)\n\(jsonString)")
            throw error
        }
    }

    @discardableResult
    public func listChannels(
        botToken: String
    ) async throws -> [SlackModel.Channel] {
        // https://api.slack.com/methods/conversations.invite
        let (data, _) = try await APIService().send(
            url: URL(string: "https://slack.com/api/conversations.list")!,
            httpMethod: .get,
            headers: [
                "Content-type": "application/json; charset=utf-8",
                "Authorization": "Bearer \(botToken)"
            ],
            parameters: [:]
        )
        
        try parseError(data: data)

        do {
            let response = try JSONDecoder().decode(SlackModel.ChannelsResponse.self, from: data)
            return response.channels
        } catch let error as DecodingError {
            throw error
        } catch {
            throw error
        }
    }

    @discardableResult
    public func inviteUsers(
        _ users: [String],
        channelId: String,
        botToken: String
    ) async throws -> SlackModel.Channel {
        // https://api.slack.com/methods/conversations.invite
        let (data, _) = try await APIService().send(
            url: URL(string: "https://slack.com/api/conversations.invite")!,
            httpMethod: .post,
            headers: [
                "Content-type": "application/json; charset=utf-8",
                "Authorization": "Bearer \(botToken)"
            ],
            parameters: [
                "channel": channelId,
                "users": users.joined(separator: ",")
            ]
        )

        try parseError(data: data)

        do {
            let response = try JSONDecoder().decode(SlackModel.ChannelResponse.self, from: data)
            return response.channel
        } catch let error as DecodingError {
            throw error
        } catch {
            throw error
        }
    }

    @discardableResult
    public func slack(
        topic: String,
        channelId: String,
        botToken: String
    ) async throws -> SlackModel.Channel {
        // https://api.slack.com/methods/conversations.setTopic
        // Works with botToken && having to add the bot (Slacker app) to the destination channel manualy before
        let (data, _) = try await APIService().send(
            url: URL(string: "https://slack.com/api/conversations.setTopic")!,
            httpMethod: .post,
            headers: [
                "Content-type": "application/json; charset=utf-8",
                "Authorization": "Bearer \(botToken)"
            ],
            parameters: [
                "channel": channelId,
                "topic": topic
            ]
        )

        try parseError(data: data)

        do {
            let response = try JSONDecoder().decode(SlackModel.ChannelResponse.self, from: data)
            return response.channel
        } catch let error as DecodingError {
            throw error
        } catch {
            throw error
        }
    }

    @discardableResult
    public func getConversation(
        // topic: String,
        // channelId: String,
        excludeArchived: Bool = true,
        limit: Int = 1000,
        types: String = "public_channel", // public_channel, private_channel, mpim, im
        botToken: String
    ) async throws -> [SlackModel.Channel] {
        // https://api.slack.com/methods/conversations.list
        // Works with botToken && having to add the bot (Slacker app) to the destination channel manualy before
        let (data, _) = try await APIService().send(
            url: URL(string: "https://slack.com/api/conversations.list")!,
            httpMethod: .get,
            headers: [
                "Content-type": "application/json; charset=utf-8",
                "Authorization": "Bearer \(botToken)"
            ],
            parameters: [
                "exclude_archived": excludeArchived,
                "limit": limit,
                "types": types
            ]
        )

        try parseError(data: data)

        do {
            let response = try JSONDecoder().decode(SlackModel.ChannelsResponse.self, from: data)
            return response.channels
        } catch let error as DecodingError {
            throw error
        } catch {
            throw error
        }
    }

    @discardableResult
    public func slack(
        text: String,
        webhookURL url: URL
    ) async throws -> (Data, URLResponse) {
        // TODO: zakkhoyt. Parse response data, pass back
        // Send message using webhooks (legacy): https://api.slack.com/apps/A03H2L2JB9S/incoming-webhooks
        try await APIService().send(
            url: url,
            httpMethod: .post,
            parameters: ["text": text]
        )
    }

    private func parseError(data: Data) throws {
        guard let errorResponse = try? JSONDecoder().decode(
            SlackModel.ErrorResponse.self,
            from: data
        ) else { return }
        
        switch errorResponse.error {
        case "already_in_channel":
            throw Error.usersAlreadyInChannel
        case "rate_limited":
            throw Error.rateLimited
        default:
            throw Error.apiResponseError(message: errorResponse.error)
        }
    }
}
