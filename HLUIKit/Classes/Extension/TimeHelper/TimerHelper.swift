//
//  TimerHelper.swift
//  BluetoothBox2
//
//  Created by mac on 2019/1/12.
//  Copyright © 2019 Mojy. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public class TimerHelper {

    public static let shared = TimerHelper()

    public var disposeBag = DisposeBag()
    public var isRuning: Bool = false

    public var countDownOutput = PublishSubject<Int>()
    private var countDownValue = 0
    private var timer: DispatchSourceTimer?
    private var tempDate: Date?

    private var listenDisposeBag = DisposeBag()

    public init() {
        listen()
    }

    public func listen() {
        listenDisposeBag = DisposeBag()
        // 重新进入前台
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: {[weak self] _ in
                // 唤醒
                if let preTime = self?.tempDate {
                    let different = Date().timeIntervalSince(preTime)

                    if let value = self?.countDownValue {
                        self?.countDownValue =  value - Int(different)
                        if value < 0 {
                            self?.stopTimer()
                            self?.countDownOutput.onNext(0)
                        }
                    }
                }
            })
            .disposed(by: listenDisposeBag)

        // 进入后台
        _ = NotificationCenter.default.rx
            .notification(UIApplication.didEnterBackgroundNotification)
            .subscribe(onNext: {[weak self] _ in
                self?.tempDate = Date()
            })
            .disposed(by: listenDisposeBag)

    }

    public func startTimer(_ maxValue: Int = Int.max, _ interval: Double = 1.0) -> Observable<Int> {

        if maxValue <= 0 {
            return Observable.error(RxError.overflow)
        }

        stopTimer()
        countDownValue = maxValue
        isRuning = true

        // 在global线程里创建一个定时器
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        // 设定这个定时器是每秒循环一次，立即开始
        timer?.schedule(deadline: .now(), repeating: interval)
        // 定时器执行的事件
        timer?.setEventHandler { [unowned self] in

            self.countDownValue -= 1
            if self.countDownValue < 0 {
                self.stopTimer()
                self.countDownOutput.onNext(-1)
                return
            }

            self.countDownOutput.onNext(self.countDownValue)
        }
        // 开启定时器
        timer?.resume()

        return self.countDownOutput.asObservable()
    }

    public func stopTimer() {

        disposeBag = DisposeBag()

        if timer != nil {
            timer?.cancel()
            timer = nil
        }

        isRuning = false
    }
}
