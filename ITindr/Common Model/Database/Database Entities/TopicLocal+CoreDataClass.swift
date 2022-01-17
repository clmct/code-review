//
//  TopicLocal+CoreDataClass.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

public class TopicLocal: NSManagedObject {
    static func getDomainTopics(context: NSManagedObjectContext) -> [Topic] {
        let request  = TopicLocal.fetchRequest()
        let localTopics = (try? context.fetch(request)) ?? []
        return localTopics.compactMap { $0.toDomainModel() }
    }
    
    static func updateOrCreate(fromContest domainTopics: [Topic],
                               context: NSManagedObjectContext) -> [TopicLocal] {
        let localTopics = (try? context.fetch(TopicLocal.fetchRequest())) ?? []

        return domainTopics.map { domainTopic in
            if let localTopic = localTopics.first(where: { $0.id == domainTopic.id }) {
                localTopic.update(with: domainTopic)
                return localTopic
            } else {
                return create(from: domainTopic, context: context)
            }
        }
    }

    static func create(from domainTopic: Topic, context: NSManagedObjectContext) -> TopicLocal {
        let localTopic = TopicLocal(context: context)
        localTopic.update(with: domainTopic)
        return localTopic
    }
    
    func update(with domainTopic: Topic) {
        id = domainTopic.id
        title = domainTopic.title
    }

    func toDomainModel() -> Topic? {
        guard let id = id, let title = title else { return nil }
        return Topic(id: id, title: title)
    }
}
