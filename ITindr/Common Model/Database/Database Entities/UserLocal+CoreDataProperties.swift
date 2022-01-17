//
//  UserLocal+CoreDataProperties.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

extension UserLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLocal> {
        return NSFetchRequest<UserLocal>(entityName: "UserLocal")
    }

    @NSManaged public var aboutMyself: String?
    @NSManaged public var avatar: String?
    @NSManaged public var name: String?
    @NSManaged public var userId: String?
    @NSManaged public var message: NSSet?
    @NSManaged public var topics: NSSet?

}

// MARK: Generated accessors for message
extension UserLocal {

    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: MessageLocal)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: MessageLocal)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}

// MARK: Generated accessors for topics
extension UserLocal {

    @objc(addTopicsObject:)
    @NSManaged public func addToTopics(_ value: TopicLocal)

    @objc(removeTopicsObject:)
    @NSManaged public func removeFromTopics(_ value: TopicLocal)

    @objc(addTopics:)
    @NSManaged public func addToTopics(_ values: NSSet)

    @objc(removeTopics:)
    @NSManaged public func removeFromTopics(_ values: NSSet)

}
