//
// Copyright 2022 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

// MARK: - FileCacheProtocol

protocol FileCacheProtocol {
    func file(forKey key: String, fileExtension: String) -> URL?
    func store(_ data: Data, with fileExtension: String, forKey key: String) throws -> URL
    func remove(forKey key: String, fileExtension: String) throws
    func removeAll() throws
}

// MARK: - FileCache

/// Implementation of `FileCacheProtocol` under `FileManager.default.temporaryDirectory`.
class FileCache {
    private let fileManager = FileManager.default
    private let folder: URL

    /// Default instance. Uses `FileCache` as the folder name.
    static let `default` = FileCache(folderName: "FileCache")

    init(folderName: String) {
        folder = fileManager.temporaryDirectory.appending(path: folderName, directoryHint: .isDirectory)
    }

    // MARK: Private

    private func filePath(forKey key: String, fileExtension: String) -> URL {
        folder.appending(path: key, directoryHint: .notDirectory).appendingPathExtension(fileExtension)
    }

    private func folderExists() -> Bool {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: folder.path(), isDirectory: &isDirectory) else {
            return false
        }
        return isDirectory.boolValue
    }

    private func createFolderIfNeeded() throws {
        guard !folderExists() else {
            return
        }
        try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
    }
}

// MARK: - FileCacheProtocol

extension FileCache: FileCacheProtocol {
    func file(forKey key: String, fileExtension: String) -> URL? {
        let url = filePath(forKey: key, fileExtension: fileExtension)
        return fileManager.isReadableFile(atPath: url.path()) ? url : nil
    }

    func store(_ data: Data, with fileExtension: String, forKey key: String) throws -> URL {
        try createFolderIfNeeded()
        let url = filePath(forKey: key, fileExtension: fileExtension)
        try data.write(to: url)
        return url
    }

    func remove(forKey key: String, fileExtension: String) throws {
        try fileManager.removeItem(at: filePath(forKey: key, fileExtension: fileExtension))
    }

    func removeAll() throws {
        guard folderExists() else {
            return
        }
        try fileManager.removeItem(at: folder)
    }
}