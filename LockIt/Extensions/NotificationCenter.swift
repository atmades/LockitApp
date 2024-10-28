import Foundation

extension NotificationCenter {
    enum SystemNotifications: String {
         case reloadTableData
         // другие уведомления
     }

    func postSystemNotification(_ notification: SystemNotifications, object: Any? = nil) {
        post(name: Notification.Name(notification.rawValue), object: object)
    }

    func addObserver(forNotification notification: SystemNotifications, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> Void) {
        addObserver(forName: Notification.Name(notification.rawValue), object: object, queue: queue, using: block)
    }
    
    
//    static let notificationIdentifierKey = "NotificationIdentifier"
//
//       func postSystemNotification(_ notification: SystemNotifications, object: Any? = nil, identifier: String? = nil) {
//           let notificationName = Notification.Name(notification.rawValue)
//           var userInfo: [AnyHashable: Any] = [:]
//           userInfo[Self.notificationIdentifierKey] = identifier
//           post(name: notificationName, object: object, userInfo: userInfo)
//       }
//
//       func addObserver(forNotification notification: SystemNotifications, object: Any? = nil, queue: OperationQueue? = nil, identifier: String? = nil, using block: @escaping (Notification) -> Void) {
//           let notificationName = Notification.Name(notification.rawValue)
//           addObserver(forName: notificationName, object: object, queue: queue) { notification in
//               // Проверяем идентификатор, если он указан
//               if let identifier = identifier,
//                  let userInfo = notification.userInfo,
//                  let notificationIdentifier = userInfo[Self.notificationIdentifierKey] as? String,
//                  identifier == notificationIdentifier {
//                   // Вызываем обработчик уведомления
//                   block(notification)
//               }
//           }
//       }
}

