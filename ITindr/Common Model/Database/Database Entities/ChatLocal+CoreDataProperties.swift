//
//  ChatLocal+CoreDataProperties.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

extension ChatLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatLocal> {
        return NSFetchRequest<ChatLocal>(entityName: "ChatLocal")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var chatListItem: ChatListItemLocal?

}
