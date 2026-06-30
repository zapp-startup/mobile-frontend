import Foundation

private struct CreateCircleRequest: Encodable {
    let name: String
    let privacy: String

    init(name: String, isPrivate: Bool) {
        self.name = name
        self.privacy = isPrivate ? "private" : "public"
    }
}

private struct JoinCircleRequest: Encodable {
    let inviteCode: String
}

final class CirclesService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchCircles() async throws -> [Circle] {
        let groups: [GroupResponse] = try await apiClient.request(Endpoint.get("/api/gamification/groups/"))
        var circles = groups.map { $0.toCircle() }
        for index in circles.indices {
            if let backendID = groups[safe: index]?.id.stringValue {
                let members = try? await fetchMembers(groupID: backendID)
                let leaderboard = try? await fetchLeaderboard(groupID: backendID)
                if let members {
                    circles[index].members = members
                    circles[index].memberCount = members.count
                }
                if let leaderboard {
                    circles[index].leaderboard = leaderboard
                }
            }
        }
        return circles
    }

    func fetchBadges() async throws -> [Badge] {
        let userBadges: [UserBadgeResponse] = try await apiClient.request(Endpoint.get("/api/gamification/user-badges/"))
        return userBadges.map { $0.toBadge() }
    }

    func fetchTargets() async throws -> [Target] {
        let payload: [TargetResponse] = try await apiClient.request(Endpoint.get("/api/gamification/monthly-targets/"))
        return payload.map { $0.toTarget() }
    }

    func createCircle(name: String, isPrivate: Bool) async throws -> Circle {
        let response: GroupResponse = try await apiClient.request(
            Endpoint.post("/api/gamification/groups/"),
            body: CreateCircleRequest(name: name, isPrivate: isPrivate)
        )
        return response.toCircle()
    }

    func joinCircle(inviteCode: String) async throws -> Circle {
        let invites: [GroupInviteResponse] = try await apiClient.request(Endpoint.get("/api/gamification/group-invites/"))
        guard let invite = invites.first(where: { $0.code == inviteCode || $0.inviteCode == inviteCode }) else {
            throw APIError.server(statusCode: 404, message: "Invite code not found.")
        }
        let _: GroupInviteResponse = try await apiClient.request(
            Endpoint.post("/api/gamification/group-invites/\(invite.id.stringValue)/accept/"),
            body: EmptyPayload()
        )
        let circles = try await fetchCircles()
        guard let matched = circles.first(where: { $0.inviteCode == inviteCode || $0.name == invite.groupName }) else {
            return circles.first ?? Circle(
                id: UUID(),
                backendID: nil,
                name: invite.groupName ?? "Joined Circle",
                privacy: .private,
                inviteCode: inviteCode,
                memberCount: 1,
                members: [],
                leaderboard: []
            )
        }
        return matched
    }

    func leaveCircle(circleId: UUID) async throws {
        let circles = try await fetchCircles()
        guard let groupID = circles.first(where: { $0.id == circleId })?.backendID else {
            throw APIError.server(statusCode: 404, message: "Circle not found.")
        }
        let _: EmptyResponse = try await apiClient.request(Endpoint.post("/api/gamification/groups/\(groupID)/leave/"))
    }

    func createTarget(title: String, targetValue: Double, unit: String) async throws -> Target {
        let response: TargetResponse = try await apiClient.request(
            Endpoint.post("/api/gamification/monthly-targets/"),
            body: TargetCreateRequest(title: title, targetValue: targetValue, unit: unit)
        )
        return response.toTarget()
    }

    func updateTargetProgress(targetID: UUID, currentValue: Double) async throws -> Target {
        let targets = try await fetchTargets()
        guard let backendID = targets.first(where: { $0.id == targetID })?.backendID else {
            throw APIError.server(statusCode: 404, message: "Target not found.")
        }
        let response: TargetResponse = try await apiClient.request(
            Endpoint.post("/api/gamification/monthly-targets/\(backendID)/progress/"),
            body: TargetProgressRequest(currentValue: currentValue)
        )
        return response.toTarget()
    }

    func fetchWeeklyReview() async throws -> Review {
        let response: ReviewResponse = try await apiClient.request(Endpoint.get("/api/gamification/reviews/weekly/"))
        return response.toReview(period: .weekly)
    }

    func fetchMonthlyReview() async throws -> Review {
        let response: ReviewResponse = try await apiClient.request(Endpoint.get("/api/gamification/reviews/monthly/"))
        return response.toReview(period: .monthly)
    }

    func completeWeeklyReview(summary: [String: String], notes: String?) async throws {
        let _: ReviewResponse = try await apiClient.request(
            Endpoint.post("/api/gamification/reviews/weekly/complete/"),
            body: ReviewCompleteRequest(summaryJSON: summary, notes: notes)
        )
    }

    func completeMonthlyReview(summary: [String: String], notes: String?) async throws {
        let _: ReviewResponse = try await apiClient.request(
            Endpoint.post("/api/gamification/reviews/monthly/complete/"),
            body: ReviewCompleteRequest(summaryJSON: summary, notes: notes)
        )
    }

    func createReflection(transactionID: String, feedback: TransactionFeedback) async throws {
        let _: TransactionReflectionResponse = try await apiClient.request(
            Endpoint.post("/api/transaction-reflections/"),
            body: ReflectionCreateRequest(
                transaction: transactionID,
                regretScore: feedback.regretScore ?? 0,
                reflection: feedback.reflection ?? "",
                satisfaction: feedback.satisfaction
            )
        )
    }

    private func fetchMembers(groupID: String) async throws -> [CircleMember] {
        let payload: [GroupMemberResponse] = try await apiClient.request(Endpoint.get("/api/gamification/groups/\(groupID)/members/"))
        return payload.enumerated().map { index, member in
            CircleMember(
                id: stableCircleUUID(from: "member-\(member.id.stringValue)"),
                displayName: member.displayName ?? member.username ?? "Member",
                rank: index + 1,
                points: member.points ?? 0,
                isCurrentUser: member.isCurrentUser ?? false
            )
        }
    }

    private func fetchLeaderboard(groupID: String) async throws -> [CircleLeaderboardEntry] {
        let payload: LeaderboardEnvelope = try await apiClient.request(
            Endpoint.get("/api/gamification/points/leaderboard/", queryItems: [URLQueryItem(name: "group_id", value: groupID)])
        )
        return payload.results.enumerated().map { index, entry in
            CircleLeaderboardEntry(
                id: stableCircleUUID(from: "leader-\(entry.userID ?? "\(index)")"),
                memberName: entry.displayName ?? "Member",
                rank: entry.rank ?? index + 1,
                score: entry.points ?? 0
            )
        }
    }
}

private struct EmptyPayload: Encodable {}

private struct GroupResponse: Decodable {
    let id: FlexibleIdentifier
    let name: String?
    let privacy: String?
    let inviteCode: String?
    let memberCount: Int?

    func toCircle() -> Circle {
        Circle(
            id: stableCircleUUID(from: "group-\(id.stringValue)"),
            backendID: id.stringValue,
            name: name ?? "Circle",
            privacy: CirclePrivacy(rawValue: privacy ?? "private") ?? .private,
            inviteCode: inviteCode ?? "",
            memberCount: memberCount ?? 0,
            members: [],
            leaderboard: []
        )
    }
}

private struct GroupInviteResponse: Decodable {
    let id: FlexibleIdentifier
    let code: String?
    let inviteCode: String?
    let groupName: String?
}

private struct GroupMemberResponse: Decodable {
    let id: FlexibleIdentifier
    let username: String?
    let displayName: String?
    let points: Int?
    let isCurrentUser: Bool?
}

private struct LeaderboardEnvelope: Decodable {
    let results: [GroupLeaderboardRow]
}

private struct GroupLeaderboardRow: Decodable {
    let userID: String?
    let displayName: String?
    let rank: Int?
    let points: Int?
}

private struct UserBadgeResponse: Decodable {
    let id: FlexibleIdentifier
    let badgeTitle: String?
    let badgeDescription: String?
    let unlockedAt: String?
    let iconName: String?

    func toBadge() -> Badge {
        Badge(
            id: stableCircleUUID(from: "badge-\(id.stringValue)"),
            title: badgeTitle ?? "Badge",
            description: badgeDescription ?? "",
            iconName: iconName ?? "star.fill",
            unlockedAt: unlockedAt
        )
    }
}

private struct TargetResponse: Decodable {
    let id: FlexibleIdentifier
    let title: String?
    let targetValue: Double?
    let currentValue: Double?
    let unit: String?
    let status: String?
    let type: String?

    func toTarget() -> Target {
        Target(
            id: stableCircleUUID(from: "target-\(id.stringValue)"),
            backendID: id.stringValue,
            title: title ?? "Target",
            type: type ?? "Savings",
            targetValue: targetValue ?? 0,
            currentValue: currentValue ?? 0,
            unit: unit ?? "USD",
            status: TargetStatus(rawValue: status ?? "active") ?? .active
        )
    }
}

private struct TargetCreateRequest: Encodable {
    let title: String
    let targetValue: Double
    let unit: String
    let type: String = "Savings"
}

private struct TargetProgressRequest: Encodable {
    let currentValue: Double
}

private struct ReviewResponse: Decodable {
    let reviewedCount: Int?
    let pendingCount: Int?
    let prompts: [ReviewPromptResponse]?
    let submittedAt: String?

    func toReview(period: ReviewPeriod) -> Review {
        Review(
            id: stableCircleUUID(from: "review-\(period.rawValue)"),
            period: period,
            reviewedCount: reviewedCount ?? 0,
            pendingCount: pendingCount ?? 0,
            prompts: (prompts ?? []).map {
                ReviewPrompt(
                    id: stableCircleUUID(from: "prompt-\($0.id.stringValue)"),
                    question: $0.question ?? "Reflection",
                    answer: $0.answer
                )
            },
            reflections: [],
            submittedAt: submittedAt
        )
    }
}

private struct ReviewPromptResponse: Decodable {
    let id: FlexibleIdentifier
    let question: String?
    let answer: String?
}

private struct ReviewCompleteRequest: Encodable {
    let summaryJSON: [String: String]
    let notes: String?
}

private struct TransactionReflectionResponse: Decodable {
    let id: FlexibleIdentifier?
}

private struct ReflectionCreateRequest: Encodable {
    let transaction: String
    let regretScore: Int
    let reflection: String
    let satisfaction: Int?
}

private func stableCircleUUID(from input: String) -> UUID {
    var hash: UInt64 = 2166136261
    for byte in input.utf8 {
        hash = (hash ^ UInt64(byte)) &* 16777619
    }
    let hex = String(format: "%016llx%016llx", hash, hash ^ 0x517cc1b727220a95)
    let formatted = "\(hex.prefix(8))-\(hex.dropFirst(8).prefix(4))-\(hex.dropFirst(12).prefix(4))-\(hex.dropFirst(16).prefix(4))-\(hex.dropFirst(20).prefix(12))"
    return UUID(uuidString: formatted) ?? UUID()
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
