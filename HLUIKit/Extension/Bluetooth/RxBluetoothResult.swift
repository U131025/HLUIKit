import Foundation

enum RxBluetoothResult<T, E> {
    case success(T)
    case error(E)
}
