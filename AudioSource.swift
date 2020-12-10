//
//  AudioSource+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/9/20.
//
//

import Foundation
import CoreData

@objc(AudioSource)
public class AudioSource: NSManagedObject, Identifiable {
    
    private var fileFetcher: AudioFileFetcher = AudioFileManager.shared
    
    public var id: Int {
        get { return Int(id_) }
        set { id_ = Int64(newValue) }
    }
    
    var name: String {
        get { return name_! }
        set { name_ = newValue }
    }
    
    var url: URL {
        fileFetcher.url(for: self)
    }
    
    var filename: String {
        get { return filename_! }
        set { filename_ = newValue }
    }
    
    var fileExtension: String {
        get { return fileExtension_! }
        set { fileExtension_ = newValue }
    }
    
    var filenameWithExt: String {
        return filename + "." + fileExtension
    }

}

extension AudioSource {
    
    static func source(id: Int, context: NSManagedObjectContext) -> AudioSource? {
        let request: NSFetchRequest<AudioSource> = AudioSource.fetchRequest()
        request.predicate = NSPredicate(format: "id_ == %ld", id)
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

extension AudioSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioSource> {
        return NSFetchRequest<AudioSource>(entityName: "AudioSource")
    }

    @NSManaged private var fileExtension_: String?
    @NSManaged private var filename_: String?
    @NSManaged private var id_: Int64
    @NSManaged public var isUserImport: Bool
    @NSManaged public var name_: String?

}
