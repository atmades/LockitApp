import Foundation

final class ContactNameConverter {
    
    // Пояснение: введенное "Name" "LastName" за меняется на "Name_LastName", введнное "Name Name" "LastName" на "Name~Name_LastName". Пробелы вначале и вконце удаляются
    
    func convertSystemToPresent(inputName: String) -> String {
        var name: String = ""
        var lastName: String = ""
        
        // Проверка наличия Фамилии
        if inputName.contains("_") {
            let separatedStrings = inputName.components(separatedBy: "_")
            name = separatedStrings[0]
            lastName = separatedStrings[1]
        } else {
            name = inputName
        }
        
        // Проверка наличия пробелов
        if name.contains("~") {
            name = name.replacingOccurrences(of: "~", with: " ")
        }
        if lastName.contains("~") {
            lastName = lastName.replacingOccurrences(of: "~", with: " ")
        }
        
        let outputName = name + " " + lastName
        return outputName
    }
    
    // Преобразуем введенные Имя и Фамилия в формат для сохранения
    func convertInputToSave(name: String, lastName: String?) -> String {
        // удаление лишних пробелов в начале и в конце имени
        var fullName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if var lastName = lastName, !lastName.isEmpty {
            // удаление лишних пробелов в начале и в конце фамилии
            lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
            // совмещение имени и фамилии
            fullName = fullName + "_" + lastName
        }
        // удаление знака тильды "~" с заменой на дефис "-"
        fullName = fullName.replacingOccurrences(of: "~", with: "-")
        // замена знака проблела " " на "~"
        fullName = fullName.replacingOccurrences(of: " ", with: "~")
        return fullName
    }
    
    func convertSystemToInput(inputName: String) -> (name: String, lastName: String?) {
        var name: String = ""
        var lastName: String = ""
        
        // Проверка на наличие фамилии
        if inputName.contains("_") {
            let separatedStrings = inputName.components(separatedBy: "_")
            name = separatedStrings[0]
            lastName = separatedStrings[1]
        } else {
            name = inputName
        }
        // замена тильды на пробел, если есть
        if name.contains("~") {
            name = name.replacingOccurrences(of: "~", with: " ")
        }
        
        // замена тильды на пробел в фамилии, если есть
        if lastName.contains("~") {
            lastName = lastName.replacingOccurrences(of: "~", with: " ")
        }
        
        if !lastName.isEmpty {
            return (name: name, lastName: lastName)
        } else {
            return (name: name, lastName: nil)
        }
    }
}
