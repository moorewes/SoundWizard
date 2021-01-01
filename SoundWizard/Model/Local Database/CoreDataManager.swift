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
        
        // TODO: Remove, testing only
        if let source = AudioSource.allUserSources(context: viewContext).first?.asMetadata {
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
        EQDetectiveLevel.storeBundleLevelsIfNeeded(context: viewContext)
        CDEQMatchLevel.storeBundleLevelsIfNeeded(context: viewContext)
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
    
    private func addScore(_ score: Int, to level: Level) {
        switch level.game {
        case .eqDetective:
            EQDetectiveLevel.level(level.number, context: viewContext)?.addScore(score: score)
        case .eqMatch:
            CDEQMatchLevel.level(level.number, context: viewContext)?.addScore(score: score)
        }
    }
}

extension CoreDataManager: LevelFetching {
    func fetchLevels(for game: Game) -> [Level] {
        switch game {
        case .eqDetective:
            return allEQDLevels()
        case .eqMatch:
            return CDEQMatchLevel.levels(context: viewContext).map { $0.level }
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
        addScore(score, to: level)
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
        let source = AudioSource.createNew(in: viewContext, from: metadata)
        CDEQMatchLevel.generateDBLevels(for: [source], context: viewContext)
        save()
    }
    
    func removeUserAudioFile(_ metadata: AudioMetadata) {
        guard let source = AudioSource.source(id: metadata.id, context: viewContext) else {
            print("couldn't find audio source to delete: ", metadata.filename)
            return
        }
        //source.associatedLevels.forEach { viewContext.delete($0) }
        viewContext.delete(source)
        
        if save() {
            AudioFileManager.shared.deleteUserFile(metadata)
            print("deleted source: ", metadata.name)
        }
    } 
}
