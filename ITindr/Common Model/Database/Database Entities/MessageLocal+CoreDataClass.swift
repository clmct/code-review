//
//  MessageLocal+CoreDataClass.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

public class MessageLocal: NSManagedObject {
    static func getDomainMessages(forChat chatId: String, context: NSManagedObjectContext) -> [Message] {
        let request = MessageLocal.fetchRequest()
        request.predicate = NSPredicate(format: "chatId == \"\(chatId)\"")
        return (try? context.fetch(request).sorted { message1, message2 in
            return Date.isIncreasingDateOrder(date1: message1.createdAt,
                                             date2: message2.createdAt)
        }.compactMap { $0.toDomainModel() }) ?? []
    }
    
    static func updateOrCreate(fromContest domainMessages: [Message],
                               chatId: String,
                               context: NSManagedObjectContext) -> [MessageLocal] {
        return domainMessages.map { domainMessage in
            return updateOrCreate(from: domainMessage, chatId: chatId, context: context)
        }
    }
    
    static func updateOrCreate(from domainMessage: Message,
                               chatId: String,
                               context: NSManagedObjectContext) -> MessageLocal {
        let request = MessageLocal.fetchRequest()
        request.predicate = NSPredicate(format: "id == \"\(domainMessage.id)\"")
    
        guard let localMessage = try? context.fetch(request).first else {
            return create(from: domainMessage, chatId: chatId, context: context)
        }
    
        localMessage.update(with: domainMessage, chatId: chatId, context: context)
        return localMessage
    }
    
    static func create(from domainMessage: Message,
                       chatId: String,
                       context: NSManagedObjectContext) -> MessageLocal {
        let localMessage = MessageLocal(context: context)
        localMessage.update(with: domainMessage, chatId: chatId, context: context)
        return localMessage
    }
    
    func update(with domainMessage: Message, chatId: String, context: NSManagedObjectContext) {
        id = domainMessage.id
        self.chatId = chatId
        text = domainMessage.text
        createdAt = Date.from(string: domainMessage.createdAt)
        attachments = domainMessage.attachments
        user = UserLocal.getOrCreate(from: domainMessage.user, context: context)
    }
    
    func toDomainModel() -> Message? {
        guard let domainUser = user?.toDomainModel() else { return nil }
    
        return Message(
            id: id ?? "",
            text: text,
            createdAt: createdAt?.toServerFormat() ?? "",
            attachments: attachments,
            user: domainUser)
    }
}
