//
//  ChatListItemLocal+CoreDataClass.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

public class ChatListItemLocal: NSManagedObject {
    static func updateOrCreate(fromContest domainItems: [ChatListItem],
                               context: NSManagedObjectContext) -> [ChatListItemLocal] {
        return domainItems.map { domainItem in
            return updateOrCreate(from: domainItem, context: context)
        }
    }
    
    static func updateOrCreate(from domainItem: ChatListItem,
                               context: NSManagedObjectContext) -> ChatListItemLocal {
        let request = ChatListItemLocal.fetchRequest()
        request.predicate = NSPredicate(format: "chat.id == \"\(domainItem.chat.id)\"")
        guard let localItem = try? context.fetch(request).first else {
            return create(from: domainItem, context: context)
        }
        
        localItem.update(with: domainItem, context: context)
        return localItem
    }
    
    static func getDomainItems(context: NSManagedObjectContext) -> [ChatListItem] {
        let request = ChatListItemLocal.fetchRequest()
        let localItems = (try? context.fetch(request)) ?? []
        
        return localItems.sorted { item1, item2 in
            return Date.isIncreasingDateOrder(date1: item1.lastMessage?.createdAt,
                                              date2: item2.lastMessage?.createdAt)
        }.compactMap { $0.toDomainModel() }
    }
    
    static func create(from domainItem: ChatListItem, context: NSManagedObjectContext) -> ChatListItemLocal {
        let localItem = ChatListItemLocal(context: context)
        localItem.update(with: domainItem, context: context)
        return localItem
    }
    
    func update(with domainItem: ChatListItem, context: NSManagedObjectContext) {
        chat = ChatLocal.getOrCreate(from: domainItem.chat, context: context)
        guard let domainMessage = domainItem.lastMessage else { return }
        lastMessage = MessageLocal.updateOrCreate(from: domainMessage,
                                                  chatId: domainItem.chat.id,
                                                  context: context)
    }
    
    func toDomainModel() -> ChatListItem? {
        guard let domainChat = chat?.toDomainModel() else { return nil }
        return ChatListItem(chat: domainChat, lastMessage: lastMessage?.toDomainModel())
    }
}
