#include <SoftwareSerial.h>

SoftwareSerial BTSerial(6, 5); // RX, TX (아두이노 기준)

void setup() {
  Serial.begin(9600);
  BTSerial.begin(9600);
  Serial.println("=== AT Test 시작 ===");
}

void loop() {
  if (BTSerial.available()) {
    Serial.write(BTSerial.read());
  }
  if (Serial.available()) {
    BTSerial.write(Serial.read());
  }
}
