//
//  ChatListItemLocal+CoreDataProperties.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

extension ChatListItemLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatListItemLocal> {
        return NSFetchRequest<ChatListItemLocal>(entityName: "ChatListItemLocal")
    }

    @NSManaged public var chat: ChatLocal?
    @NSManaged public var lastMessage: MessageLocal?

}
