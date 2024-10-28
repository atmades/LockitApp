import Foundation

final class SortManager: SortManagerProtocol {
    func sortItems(items: [ItemForPresent], sortBy: SortType) -> [ItemForPresent] {
        var sorted: [ItemForPresent]
        switch sortBy {
        case .nameA:
            sorted = sortNameA(items: items)
        case .nameZ:
            sorted = sortNameZ(items: items)
        case .sizeBig:
            sorted = sortSizeBig(items: items)
        case .sizeSmal:
            sorted = sortSizeSmall(items: items)
        case .dateNew:
            sorted = sortDateNew(items: items)
        case .dateOld:
            sorted = sortDateOld(items: items)
        case .type:
            sorted = sortType(items: items)
        }
        return sorted
    }
}

private extension SortManager {
    private func sortSizeSmall(items: [ItemForPresent]) -> [ItemForPresent] {
        return items.sorted { ($0.size ?? "") > ($1.size ?? "") }
    }
    
    private func sortSizeBig(items: [ItemForPresent]) -> [ItemForPresent] {
        return items.sorted { ($0.size ?? "") < ($1.size ?? "") }
    }
    
    private func sortNameA(items: [ItemForPresent]) -> [ItemForPresent] {
        return items.sorted { $0.name < $1.name }
    }
    
    private func sortNameZ(items: [ItemForPresent]) -> [ItemForPresent] {
        return items.sorted { $0.name > $1.name }
    }
    
    private func sortDateNew(items: [ItemForPresent]) -> [ItemForPresent] {
        return items.sorted { ($0.dateModoficated ?? Date()) > ($1.dateModoficated ?? Date()) }
    }
    
    private func sortDateOld(items: [ItemForPresent]) -> [ItemForPresent] {
        return items.sorted { ($0.dateModoficated ?? Date()) < ($1.dateModoficated ?? Date()) }
    }
    
    private func sortType(items: [ItemForPresent]) -> [ItemForPresent] {
        let sortedItems = items.sorted { (firstItem, secondItem) -> Bool in
            if firstItem.type == .folder && secondItem.type == .file {
                return true // Папки идут перед файлами
            } else if firstItem.type == .file && secondItem.type == .folder {
                return false // Файлы идут после папок
            } else {
                return firstItem.name < secondItem.name
            }
        }
        return sortedItems
    }
}
