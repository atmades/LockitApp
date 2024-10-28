import Foundation

protocol DecoderItem {
//    func decodeItem(from data: Data) -> Displayable?
}

protocol EncoderItem {
    func encodeStruct<T: Codable>(_ value: T) -> Data?
}
