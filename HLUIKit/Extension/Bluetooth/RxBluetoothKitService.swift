//
//  RxBluetoothService.swift
//  SmartLock
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import RxBluetoothKit
import RxSwift
import RxCocoa
import CoreBluetooth

extension String {
    var uuid: CBUUID {
        return CBUUID(string: self)
    }
}

class PeripheralCharacteristicConfig: NSObject {
    var writeChrUUIDStr: String?
    var readChrUUIDStr: String?
    var notifyChrUUIDStr: String?
    var writeChr: Characteristic?
    var readChr: Characteristic?
    var notifyChr: Characteristic?
    func addCharacteristic(_ chr: Characteristic?) {

        guard let chr = chr else { return }
        if chr.uuid.uuidString.uppercased() == writeChrUUIDStr?.uppercased() {
            writeChr = chr
        }
        if chr.uuid.uuidString.uppercased() == readChrUUIDStr?.uppercased() {
            readChr = chr
        }
        if chr.uuid.uuidString.uppercased() == notifyChrUUIDStr?.uppercased() {
            notifyChr = chr
        }
    }

    func isNotifyChr(_ chr: Characteristic?) -> Bool {
        guard let chr = chr else { return false }
        if chr.uuid.uuidString.uppercased() == notifyChrUUIDStr?.uppercased() {
            return true
        }
        return false
    }
}

class RxBluetoothKitService {

    static let shared = RxBluetoothKitService()

    //发送线程
    private let sendQueue = OperationQueue().then { (queue) in
        queue.maxConcurrentOperationCount = 1
    }

    typealias Disconnection = (Peripheral, DisconnectionReason?)

    var peripheralsDic = [String: ScannedPeripheral]()
    var autoDisposeBag = DisposeBag()

    // MARK: - Public outputs
    var scanningOutput: Observable<ScannedPeripheral> {
        return scanningSubject.share(replay: 1, scope: .forever).asObservable()
    }

    var connectionResultOutput: Observable<RxBluetoothResult<Peripheral, Error>> {
        return connectionResultSubject.asObservable()
    }

    var disconnectionReasonOutput: Observable<RxBluetoothResult<Disconnection, Error>> {
        return disconnectionSubject.asObservable()
    }

    var discoveredCharacteristicsOutput: Observable<Characteristic> {
        return discoveredCharacteristicsSubject.asObservable()
    }

    var readValueOutput: Observable<RxBluetoothResult<Characteristic, Error>> {
        return readValueSubject.asObservable()
    }

    var writeValueOutput: Observable<RxBluetoothResult<Characteristic, Error>> {
        return writeValueSubject.asObservable()
    }

    // 通知输出
    var updatedValueAndNotificationOutput: Observable<RxBluetoothResult<Characteristic, Error>> {
        return updatedValueAndNotificationSubject.asObservable()
    }

    // MARK: - Private subjects
    private let discoveredCharacteristicsSubject = PublishSubject<Characteristic>()

    private let scanningSubject = PublishSubject<ScannedPeripheral>()

    private let connectionResultSubject = PublishSubject<RxBluetoothResult<Peripheral, Error>>()

    private let disconnectionSubject = PublishSubject<RxBluetoothResult<Disconnection, Error>>()

    private let readValueSubject = PublishSubject<RxBluetoothResult<Characteristic, Error>>()

    private let writeValueSubject = PublishSubject<RxBluetoothResult<Characteristic, Error>>()

    private let updatedValueAndNotificationSubject = PublishSubject<RxBluetoothResult<Characteristic, Error>>()

    // MARK: - Private fields

    private let centralManager = CentralManager(queue: .main)

    private let scheduler: ConcurrentDispatchQueueScheduler

    private var disposeBag = DisposeBag()

    private var peripheralConnections: [Peripheral: Disposable] = [:]

    private var scanningDisposable: Disposable?

//    private var connectionDisposable: Disposable!

    private var notificationDisposables: [Characteristic: Disposable] = [:]

    private var peripheralCharacteristics: [Peripheral: PeripheralCharacteristicConfig] = [:]

    // MARK: - Initialization
    init() {
        let timerQueue = DispatchQueue(label: Constant.Strings.defaultDispatchQueueLabel)
        scheduler = ConcurrentDispatchQueueScheduler(queue: timerQueue)
    }
    // MARK: 扫描
    func startScan(serviceUUIDs: [CBUUID]? = nil) -> Observable<ScannedPeripheral> {

        peripheralsDic.removeAll()
        stopScanning()

        scanningDisposable = centralManager
            .observeState()
            .startWith(centralManager.state)
            .filter { $0 == .poweredOn }
            .subscribeOn(MainScheduler.instance)
            .flatMap({ [weak self] _ -> Observable<ScannedPeripheral> in
                guard let `self` = self else {
                    return Observable.empty()
                }

                return self.centralManager.scanForPeripherals(withServices: serviceUUIDs, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            })
            .subscribe(onNext: { [weak self] scannedPeripheral in
                guard let `self` = self else {
                    return
                }

                // 需要根据identifier进行过滤
                let key = scannedPeripheral.peripheral.identifier.uuidString.uppercased()

                if self.peripheralsDic[key] == nil {
                    self.scanningSubject.onNext(scannedPeripheral)
                }
                self.peripheralsDic[key] = scannedPeripheral
            })

        return scanningOutput
    }

    func stopScanning() {
        scanningDisposable?.dispose()
    }

    // MARK: 连接
    func connect(for peripheral: Peripheral, serviceUUIDs: [CBUUID]? = nil, characteristicConfig: PeripheralCharacteristicConfig? = nil) -> Self {

        let isConnected = peripheral.isConnected
        if isConnected == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.connectionResultSubject.onNext(RxBluetoothResult.success(peripheral))
            }
            return self
        }
        peripheralCharacteristics[peripheral] = characteristicConfig

        let disposable = peripheral.establishConnection()
            .do(onNext: {[weak self] (peripheral) in

                self?.observeDisconnect(for: peripheral)

                if peripheral.isConnected {
                    self?.connectionResultSubject.onNext(RxBluetoothResult.success(peripheral))
                } else {
                    self?.connectionResultSubject.onNext(RxBluetoothResult.error(RxError.noElements))
                }
            })
            .flatMap { $0.discoverServices(serviceUUIDs) }
            .flatMap({ (services) -> Observable<Characteristic> in
                return Observable.create { (obs) -> Disposable in

                    var disposabels = [Disposable]()
                    for service in services {

                        let disposabel = service
                            .discoverCharacteristics(nil)
                            .subscribe(onSuccess: { (characteristics) in

                                characteristics.forEach { (char) in
                                    obs.onNext(char)
                                }
                            })

                        disposabels.append(disposabel)
                    }

                    return Disposables.create(disposabels)
                }
            })
            .subscribe(onNext: {[weak self] (chr) in
                guard let `self` = self else { return }

                self.discoveredCharacteristicsSubject.onNext(chr)

                if let config = self.peripheralCharacteristics[peripheral] {

                    config.addCharacteristic(chr)
                    if config.isNotifyChr(chr) {

                        // 开启通知
                        self.observeValueUpdateAndSetNotification(for: chr)
                        self.observeNotifyValue(peripheral: peripheral, characteristic: chr)
                    }
                }

            }, onError: { (_) in

            })

        peripheralConnections[peripheral] = disposable

        return self
    }

    func disconnect(_ peripheral: Peripheral) {
        guard let disposable = peripheralConnections[peripheral] else {
            return
        }
        disposable.dispose()
        peripheralConnections[peripheral] = nil
        peripheralCharacteristics[peripheral] = nil
    }

    func autoConnected(_ peripheral: Peripheral) {

        disconnectionSubject
            .subscribe(onNext: {[weak self] (result) in

                guard let `self` = self else { return }
                if case let .success(disconnection) = result {

                    if disconnection.0.peripheral.identifier == peripheral.identifier {

                        if let config = self.peripheralCharacteristics[peripheral] {
                            _ = self.connect(for: peripheral, characteristicConfig: config)
                        } else {
                            _ = self.connect(for: peripheral)
                        }
                    }
                }

            }).disposed(by: autoDisposeBag)
    }

    // 监听断开连接状态
    private func observeDisconnect(for peripheral: Peripheral) {
        centralManager.observeDisconnect(for: peripheral).subscribe(onNext: { [unowned self] (peripheral, reason) in
            self.disconnectionSubject.onNext(RxBluetoothResult.success((peripheral, reason)))
            self.disconnect(peripheral)
        }, onError: { [unowned self] error in
            self.disconnectionSubject.onNext(RxBluetoothResult.error(error))
        }).disposed(by: disposeBag)
    }

    //
    // MARK: - Reading from and writing to a characteristic
    func readValueFrom(_ characteristic: Characteristic) {
        characteristic.readValue().subscribe(onSuccess: { [unowned self] characteristic in
            self.readValueSubject.onNext(RxBluetoothResult.success(characteristic))
        }, onError: { [unowned self] error in
            self.readValueSubject.onNext(RxBluetoothResult.error(error))
        }).disposed(by: disposeBag)
    }

    func writeValueTo(characteristic: Characteristic, data: Data) {
        guard let writeType = characteristic.determineWriteType() else {
            return
        }

        characteristic
            .writeValue(data, type: writeType)
            .subscribe(onSuccess: { [unowned self] characteristic in
                self.writeValueSubject.onNext(RxBluetoothResult.success(characteristic))

                }, onError: { [unowned self] error in
                    self.writeValueSubject.onNext(RxBluetoothResult.error(error))

            }).disposed(by: disposeBag)
    }

    // MARK: - Characteristic notifications

    // observeValueUpdateAndSetNotification(:_) returns a disposable from subscription, which triggers notifying start
    // on a selected characteristic.
    func observeValueUpdateAndSetNotification(for characteristic: Characteristic) {
        if notificationDisposables[characteristic] != nil {
            self.updatedValueAndNotificationSubject.onNext(RxBluetoothResult.error(RxBluetoothServiceError.redundantStateChange))
        } else {
            let disposable = characteristic.observeValueUpdateAndSetNotification()
            .subscribe(onNext: { [weak self] (characteristic) in
                print("\n===== 🚖 ble respond data: \(String(describing: characteristic.value))")
                self?.updatedValueAndNotificationSubject.onNext(RxBluetoothResult.success(characteristic))
            }, onError: { [weak self] (error) in
                self?.updatedValueAndNotificationSubject.onNext(RxBluetoothResult.error(error))
            })

            notificationDisposables[characteristic] = disposable
        }
    }

    func disposeNotification(for characteristic: Characteristic) {
        if let disposable = notificationDisposables[characteristic] {
            disposable.dispose()
            notificationDisposables[characteristic] = nil
        } else {
            self.updatedValueAndNotificationSubject.onNext(RxBluetoothResult.error(RxBluetoothServiceError.redundantStateChange))
        }
    }

    // observeNotifyValue tells us when exactly a characteristic has changed it's state (e.g isNotifying).
    // We need to use this method, because hardware needs an amount of time to switch characteristic's state.
    func observeNotifyValue(peripheral: Peripheral, characteristic: Characteristic) {
        peripheral.observeNotifyValue(for: characteristic)
        .subscribe(onNext: { [unowned self] (characteristic) in
            self.updatedValueAndNotificationSubject.onNext(RxBluetoothResult.success(characteristic))
        }, onError: { [unowned self] (error) in
            self.updatedValueAndNotificationSubject.onNext(RxBluetoothResult.error(error))
        }).disposed(by: disposeBag)
    }

}

extension RxBluetoothKitService {

    // 发送数据
    func send(data: Data, for peripheral: Peripheral) -> Self {

        guard let config = peripheralCharacteristics[peripheral], let chr = config.writeChr else {
            return self
        }

        writeValueTo(characteristic: chr, data: data)

        return self
    }
    // 批量发送
    func send(datas: [Data], for peripheral: Peripheral) -> Self {

        guard let config = peripheralCharacteristics[peripheral], let chr = config.writeChr else {
            return self
        }

        for data in datas {

            sendQueue.addOperation { [unowned self] in
                self.writeValueTo(characteristic: chr, data: data)
                Thread.sleep(forTimeInterval: 0.10)
            }
        }

        return self
    }

}

enum RxBluetoothServiceError: Error {
    case redundantStateChange
}
