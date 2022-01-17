//
//  TopicLocal+CoreDataProperties.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

extension TopicLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopicLocal> {
        return NSFetchRequest<TopicLocal>(entityName: "TopicLocal")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for user
extension TopicLocal {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: UserLocal)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: UserLocal)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}
