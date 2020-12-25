//
//  UserProgressManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/3/20.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Shared Instance
    
    static let shared = CoreDataManager()
    
    // MARK: - Properties
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    var container: NSPersistentContainer
    
    @Published var audioFiles: [AudioMetadata] = []
    
    // MARK: Internal
    
    // MARK: Private
    
    private let storeName = "SoundWizard"
        
    // MARK: - Initializers
    
    init() {
        self.container = NSPersistentContainer(name: storeName)
        setupPersistentContainer()
        audioFiles = AudioSource.allSources(context: viewContext).map(\.asMetadata)
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func allEQDLevels() -> [Level] {
        var levels = EQDetectiveLevel.levels(context: viewContext).map { $0.level }
        if let source = AudioSource.allUserSources(context: viewContext).first?.asMetadata {
            print(source)
            levels.append(
                EQDLevel(id: "", game: .eqDetective, number: 999, difficulty: .moderate, audioMetadata: [source], scoreData: ScoreData(starScores: [400, 600, 800], scores: []), bandFocus: .all, filterGain: Gain(dB: 8), filterQ: 8, octaveErrorRange: 2)
            )
        }
        
        return levels
    }
    
    func allAudioFiles() -> [AudioMetadata] {
        AudioSource.allSources(context: viewContext).map { $0.asMetadata }
    }
    
    func loadInitialLevels() {
        EQDetectiveLevel.storeBundleLevelsIfNeeded(context: container.viewContext)
    }
    
    func audioSources(for metadata: [AudioMetadata]) -> [AudioSource] {
        let request: NSFetchRequest<AudioSource> = AudioSource.fetchRequest()
        let ids = metadata.map { $0.id }
        request.predicate = NSPredicate(format: "id_ in %@", argumentArray: ids)
        request.sortDescriptors = [NSSortDescriptor(key: "id_", ascending: true)]
        do {
            return try viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
        
    }
    
    // TODO: Handle save fails
    @discardableResult
    func save() -> Bool {
        guard container.viewContext.hasChanges else { return false }
        do {
            try container.viewContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    // MARK: Private
    
    private func setupPersistentContainer() {
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    private func storeObject(matching level: Level) -> EQDetectiveLevel? {
        let levels = viewContext.registeredObjects
                        .compactMap { $0 as? EQDetectiveLevel }
                        .filter { $0.id == level.id }
        if let level = levels.first {
            return level
        } else {
            return EQDetectiveLevel.level(level.number)
        }
    }
}

extension CoreDataManager: LevelFetching {
    func fetchLevels(for game: Game) -> [Level] {
        switch game {
        case .eqDetective:
            return allEQDLevels()
        }
    }
}

extension CoreDataManager: LevelStoring {
    func add(level: Level) {
        if let level = level as? EQDLevel {
            EQDetectiveLevel.createNew(level: level,
                                       audioSources: audioSources(for: level.audioMetadata),
                                       context: viewContext)
        }
    }
    
    func update(level: Level) {
        guard let score = level.scoreData.scores.last else { return }
        guard let storageLevel = storeObject(matching: level) else {
            fatalError("couldn't find matching core data object to update")
        }
        storageLevel.addScore(score: score)
    }
    
    func delete(level: Level) {
        
    }
}

extension CoreDataManager: UserAudioStore {
    var userAudioFiles: [AudioMetadata] {
        AudioSource.allUserSources(context: viewContext).map { $0.asMetadata }
    }
    
    func addUserAudioFile(name: String, url: URL) {
        let filename = url.lastPathComponent
        guard filename.isNotEmpty else {
            return
        }
        guard AudioFileManager.shared.storeUserFile(url: url) else {
            print("failed to store audio data")
            return
        }
        let metadata = AudioMetadata(id: "User.\(name)", name: name, filename: filename, isStock: false, url: url)
        AudioSource.createNew(in: viewContext, from: metadata)
        save()
    }
    
    func removeUserAudioFile(_ metadata: AudioMetadata) {
        guard let source = AudioSource.source(id: metadata.id, context: viewContext) else {
            print("couldn't find audio source to delete: ", metadata.filename)
            return
        }
        viewContext.delete(source)
        if save() {
            AudioFileManager.shared.deleteUserFile(metadata)
        }
    } 
}
