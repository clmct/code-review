//
//  UserLocal+CoreDataClass.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

public class UserLocal: NSManagedObject {
    static func getDomainUsers(withoutId userId: String, context: NSManagedObjectContext) -> [User] {
        let request = UserLocal.fetchRequest()
        request.predicate = NSPredicate(format: "userId != \"\(userId)\"")
        return (try? context.fetch(request).compactMap { $0.toDomainModel() }) ?? []
    }
    
    static func getOrCreate(from domainUser: User, context: NSManagedObjectContext) -> UserLocal {
        guard let localUser = get(fromId: domainUser.userId, context: context) else {
            return create(from: domainUser, context: context)
        }
        return localUser
    }
    
    static func get(fromId userId: String, context: NSManagedObjectContext) -> UserLocal? {
        let request = UserLocal.fetchRequest()
        request.predicate = NSPredicate(format: "userId == \"\(userId)\"")
        return try? context.fetch(request).first
    }
    
    static func updateOrCreate(fromContest domainUsers: [User],
                               context: NSManagedObjectContext) -> [UserLocal] {
        let localUsers = (try? context.fetch(UserLocal.fetchRequest())) ?? []

        return domainUsers.map { domainUser in
            if let localUser = localUsers.first(where: { $0.userId == domainUser.userId }) {
                localUser.update(with: domainUser, context: context)
                return localUser
            } else {
                return create(from: domainUser, context: context)
            }
        }
    }
    
    static func updateOrCreate(from domainProfile: User, context: NSManagedObjectContext) -> UserLocal {
        let request = UserLocal.fetchRequest()
        request.predicate = NSPredicate(format: "userId == \"\(domainProfile.userId)\"")
        guard let localProfile = try? context.fetch(request).first else {
            return UserLocal.create(from: domainProfile, context: context)
        }

        localProfile.update(with: domainProfile, context: context)
        return localProfile
    }

    static func create(from domainProfile: User, context: NSManagedObjectContext) -> UserLocal {
        let userLocal = UserLocal(context: context)
        userLocal.update(with: domainProfile, context: context)
        return userLocal
    }

    func toDomainModel() -> User? {
        guard let userId = userId else { return nil }
        return User(
            userId: userId,
            name: name ?? "",
            aboutMyself: aboutMyself,
            avatar: avatar,
            topics: topics?.compactMap { ($0 as? TopicLocal)?.toDomainModel() })
    }

    private func update(with domainProfile: User, context: NSManagedObjectContext) {
        userId = domainProfile.userId
        name = domainProfile.name
        avatar = domainProfile.avatar
        aboutMyself = domainProfile.aboutMyself
        topics = NSSet(array: TopicLocal.updateOrCreate(fromContest: domainProfile.topics ?? [],
                                                        context: context))
    }
}
