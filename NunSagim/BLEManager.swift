//
//  BLEManager.swift
//  NunSagim
//
//  Created by 정시은 on 5/22/25.
//
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isReady = false  // ✅ 전송 가능 여부 플래그

    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var txCharacteristic: CBCharacteristic?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        if let name = peripheral.name,
           name.contains("HM") || name.contains("BLE") || name.contains("BT") || name.contains("HC") {
            print("✅ 연결 시도: \(name)")
            self.connectedPeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        for characteristic in service.characteristics ?? [] {
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                txCharacteristic = characteristic
                print("✅ 전송용 characteristic 설정 완료: \(characteristic.uuid)")
                isReady = true  // ✅ 전송 준비 완료
            }
        }
    }

    func sendBraille(text: String) {
        guard let peripheral = connectedPeripheral,
              let characteristic = txCharacteristic else {
            print("⚠️ BLE 연결 안 됨")
            return
        }

        if let data = text.data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            print("📤 정답 전송: \(text)")
        }
    }
}
