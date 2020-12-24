//
//  AudioSource+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/10/20.
//
//

import Foundation
import CoreData

struct AudioMetadata: Identifiable, UIDescribing, Hashable {
    var id: String
    var name: String
    var filename: String
    var isStock: Bool
    
    var url: URL
    
    var uiDescription: String { name }
}

@objc(AudioSource)
public class AudioSource: NSManagedObject {
    private var fileFetcher: AudioFileFetcher = AudioFileManager.shared
    
    public var id: String {
        get { return id_! }
        set { id_ = newValue }
    }
    
    var name: String {
        get { return name_! }
        set { name_ = newValue }
    }
    
    var filename: String {
        get { return filename_! }
        set { filename_ = newValue }
    }
    
    var asMetadata: AudioMetadata {
        AudioMetadata(id: id, name: name, filename: filename, isStock: isStock, url: fileFetcher.url(filename: filename, isStock: isStock))
    }
    
    @discardableResult
    static func createNew(in context: NSManagedObjectContext, from metadata: AudioMetadata) -> AudioSource {
        let source = AudioSource(context: context)
        source.id = metadata.id
        source.name = metadata.name
        source.filename = metadata.filename
        source.isStock = metadata.isStock
        
        return source
    }
}

// MARK: - Fetching

extension AudioSource {
    static func allUserSources(context: NSManagedObjectContext) -> [AudioSource] {
        let request: NSFetchRequest<AudioSource> = AudioSource.fetchRequest()
        request.predicate = NSPredicate(format: "isStock == FALSE")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func source(id: String, context: NSManagedObjectContext) -> AudioSource? {
        let request: NSFetchRequest<AudioSource> = AudioSource.fetchRequest()
        request.predicate = NSPredicate(format: "id_ == %@", id)
        do {
            let source = try context.fetch(request)
            return source.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func allSources(context: NSManagedObjectContext) -> [AudioSource] {
        let request: NSFetchRequest<AudioSource> = AudioSource.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id_", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
