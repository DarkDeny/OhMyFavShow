//
// Created by Dmitry Denisov on 19.02.2022.
//

import Foundation

class PersistenceService {
    fileprivate func getFileUrl() -> URL {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor:nil,
                create:true)
        let fileURL = documentDirectory.appendingPathComponent("ohMyFavShows").appendingPathExtension("json")
        return fileURL
    }

    func loadData() -> [Show] {
        var shows = [Show]()
        do {
            let fileUrl = getFileUrl()
            let stringData = try String(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            let bytes = [UInt8](stringData.utf8)
            let data = Data(bytes: bytes, count: bytes.count)
            shows = try decoder.decode([Show].self, from: data)
        } catch {
            print(error)
        }
        return shows
    }

    func save(data: [Show]) {
        do {
            let fileURL = getFileUrl()
            let encoder = JSONEncoder()
            let stringData = try encoder.encode(data)
            try stringData.write(to: fileURL)
        } catch {
            print(error)
        }
    }
}
