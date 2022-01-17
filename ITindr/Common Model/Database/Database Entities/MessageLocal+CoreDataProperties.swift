//
//  MessageLocal+CoreDataProperties.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

extension MessageLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageLocal> {
        return NSFetchRequest<MessageLocal>(entityName: "MessageLocal")
    }

    @NSManaged public var attachments: [String]?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var chatId: String?
    @NSManaged public var user: UserLocal?
    @NSManaged public var chatListItem: ChatListItemLocal?

}
