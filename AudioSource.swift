//
//  AudioSource+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/10/20.
//
//

import Foundation
import CoreData

protocol AudioMetadata {
    var name: String { get }
    var filename: String { get }
    var isStock: Bool { get }
    var url: URL { get }
}

@objc(AudioSource)
public class AudioSource: NSManagedObject, AudioMetadata {
    
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
    
    var url: URL {
        fileFetcher.url(for: self)
    }
    
}

// MARK: - Fetching

extension AudioSource {
    
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
