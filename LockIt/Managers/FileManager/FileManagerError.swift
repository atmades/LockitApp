import Foundation

enum FileManagerError: Error, LocalizedError {
    case fileNotFound
    case directoryNotFound
    case fileAlreadyExists
    case nameIsEmpty
    case errorRename
    case failedToReadContents
    case sameFolder
    case anyError
    case parentFolderNotFound
    case errorSaveFile
    case errorCreatefolder
    case errorPhone
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return NSLocalizedString("File not found", comment: "")
        case .directoryNotFound:
            return NSLocalizedString("Directory not found", comment: "")
        case .fileAlreadyExists:
            return NSLocalizedString("File already exists", comment: "")
        case .nameIsEmpty:
            return NSLocalizedString("Enter name", comment: "")
        case .errorRename:
            return NSLocalizedString("Error Rename", comment: "")
        case .failedToReadContents:
            return NSLocalizedString("failedToReadContents", comment: "")
        case .sameFolder:
            return NSLocalizedString("Same Folder", comment: "You can't paste folder inside same folder")
        case .anyError:
            return NSLocalizedString("Any error", comment: "Comment of Any error")
        case .parentFolderNotFound:
            return NSLocalizedString("Error Rename", comment: "Parent Folder Not Found")
        case .errorSaveFile:
            return NSLocalizedString("Сan't to save file", comment: "Произошла ошибка при сохранении файла")
        case .errorCreatefolder:
            return NSLocalizedString("Сan't create folder", comment: "Произошла ошибка при создании папки")
        case .errorPhone:
            return NSLocalizedString("Enter correct phone", comment: "")
        }
    }
}
