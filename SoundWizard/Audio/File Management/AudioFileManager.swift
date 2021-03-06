//
//  AudioFileManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/9/20.
//

import Foundation

protocol AudioFileFetcher {
    func url(filename: String, isStock: Bool) -> URL
}

protocol DefaultsStore {
    func optionalBool(forKey defaultName: String) -> Bool?
    func setValue(_ value: Any?, forKey key: String)
}

extension UserDefaults: DefaultsStore {}

class AudioFileManager: AudioFileFetcher {
    static let shared = AudioFileManager()
    
    private enum DirectoryName {
        static let parent = "AudioSources/"
        static let user = parent + "User/"
        static let stock = parent + "Stock/"
    }
    
    private var defaults: DefaultsStore = UserDefaults.standard
    
    private var fileManager: FileManager {
        return FileManager.default
    }
    
    var userDocumentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
        
    private var parentDirectoryURL: URL {
        userDocumentsURL.appendingPathComponent(DirectoryName.parent)
    }
    
    private var stockDirectoryURL: URL {
        userDocumentsURL.appendingPathComponent(DirectoryName.stock)
    }
    
    private var userDirectoryURL: URL {
        userDocumentsURL.appendingPathComponent(DirectoryName.user)
    }
    
    private init() {}
    
    func url(filename: String, isStock: Bool) -> URL {
        let dir = isStock ? stockDirectoryURL : userDirectoryURL
        return dir.appendingPathComponent(filename, isDirectory: false)
    }
    
    func storeUserFile(url: URL) -> Bool {
        guard url.startAccessingSecurityScopedResource() else {
            print("denied access")
            return false
        }
        defer { url.stopAccessingSecurityScopedResource() }
        print("begin process with ", url.absoluteURL)
        let destination = userDirectoryURL.appendingPathComponent(url.lastPathComponent)
        
        do {
            let data = try Data(contentsOf: url)
            try data.write(to: destination)
            print("copied: ", url.lastPathComponent)
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    func deleteUserFile(_ metadata: AudioMetadata) {
        do {
            try fileManager.removeItem(at: metadata.url)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: Initial App Setup

extension AudioFileManager {
    private enum DefaultsKeys {
        static let directoriesAreSetup = "audioFileDirectoriesAreSetup"
        static let bundleFilesAreCopied = "bundleAudioFilesAreCopied"
        static let bundleFilesAreInDatabase = "bundleAudioFilesAreInDatabase"
    }
        
    private var directoriesAreSetup: Bool {
        get { defaults.optionalBool(forKey: DefaultsKeys.directoriesAreSetup) ?? false }
        set { defaults.setValue(newValue, forKey: DefaultsKeys.directoriesAreSetup) }
    }
    
    private var bundleFilesAreCopied: Bool {
        get { defaults.optionalBool(forKey: DefaultsKeys.bundleFilesAreCopied) ?? false }
        set { defaults.setValue(newValue, forKey: DefaultsKeys.bundleFilesAreCopied) }
    }
    
    private var bundleFilesAreInDatabase: Bool {
        get { defaults.optionalBool(forKey: DefaultsKeys.bundleFilesAreInDatabase) ?? false }
        set { defaults.setValue(newValue, forKey: DefaultsKeys.bundleFilesAreInDatabase) }
    }
    
    func performInitialSetupIfNeeded() {
        if !directoriesAreSetup {
            directoriesAreSetup = createAllDirectories()
        }
        
        if !bundleFilesAreCopied {
            bundleFilesAreCopied = copyBundleFilesToDocuments()
        }
        
        if !bundleFilesAreInDatabase {
            addBundleFilesToDatabase() { succeeded in
                self.bundleFilesAreInDatabase = succeeded
            }
        }
        
    }
    
    private func createAllDirectories() -> Bool {
        let urls = [stockDirectoryURL, userDirectoryURL]
        var succeeded = true
        
        urls.forEach { url in
            do {
                try fileManager.createDirectory(at: url,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                print(error.localizedDescription)
                succeeded = false
            }
        }
        
        return succeeded
    }
    
    private func copyBundleFilesToDocuments() -> Bool {
        var succeeded = true
        let destinationDir = stockDirectoryURL
        
        BundleAudioFile.allFiles.forEach { file in
            if let url = Bundle.main.url(forResource: file.filename, withExtension: file.fileExtension) {
                let destination = destinationDir.appendingPathComponent(file.fullFilename,
                                                                        isDirectory: false)
                do {
                    try fileManager.copyItem(at: url, to: destination)
                    print("copied \(file.name)")
                } catch {
                    print(error.localizedDescription)
                    succeeded = false
                }
            }
        }
        
        return succeeded
    }
    
    private func addBundleFilesToDatabase(onCompletion handler: @escaping (Bool) -> Void ) {
        var succeeded = true
        let context = CoreDataManager.shared.viewContext
        
        for file in BundleAudioFile.allFiles {
            guard AudioSource.source(id: file.id, context: context) == nil else { continue }
            let source = AudioSource(context: context)
            source.id = file.id
            source.name = file.name
            source.filename = file.fullFilename
            source.isStock = true
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
            succeeded = false
        }
        
        handler(succeeded)
    }
}
