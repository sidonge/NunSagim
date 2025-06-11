#include <SoftwareSerial.h>

// 점자 모듈 핀 및 개수 세팅
int dataPin = 2;
int latchPin = 3;
int clockPin = 4;
int no_module = 3;

SoftwareSerial soft(5, 6); // RX, TX

void setup() {
  Serial.begin(9600);
  soft.begin(9600);
  pinMode(dataPin, OUTPUT);
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  clearBraille();
  delay(1000);
  Serial.println("🟡 HM-10 수신 대기 중...");
}

void loop() {
  if (soft.available()) {
    String str = "";
    while (soft.available()) {
      str += (char)soft.read();
      delay(2);
    }
    str.trim();

    Serial.print("📥 수신: ");
    Serial.println(str);

    if (str == "ㄱ") {
      byte dots[3] = { (1 << 1), 0, 0 }; // dot 4
      printBraille(dots);
    }
    else if (str == "ㄴ") {
      byte dots[3] = { (1 << 0) | (1 << 1), 0, 0 }; // dot 1, 4
      printBraille(dots);
    }
    else if (str == "ㄷ") {
      byte dots[3] = { (1 << 1) | (1 << 2), 0, 0 }; // dot 2, 4
      printBraille(dots);
    }
    else if (str == "ㄹ") {
      byte dots[3] = { (1 << 3) , 0, 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅁ") {
      byte dots[3] = { (1 << 0) | (1 << 3), 0, 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅊ") {
      byte dots[3] = { (1 << 3) | (1 << 5), 0, 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅋ") {
      byte dots[3] = { (1 << 0) | (1 << 1) | (1 << 2), 0, 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅌ") {
      byte dots[3] = { (1 << 0) | (1 << 2) | (1 << 3), 0, 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅍ") {
      byte dots[3] = { (1 << 0) | (1 << 1) | (1 << 3), 0, 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅎ") {
      byte dots[3] = { (1 << 3) | (1 << 4) | (1 << 5), 0, 0 }; // dot 3, 5, 6
      printBraille(dots);
    }
    else if (str == "ㅏ") {
      byte dots[3] = { 0, (1 << 0) | (1 << 2) | (1 << 5), 0 }; // dot 1, 2, 6 on module 1
      printBraille(dots);
    }
    else if (str == "ㅑ") {
      byte dots[3] = { 0, (1 << 1) | (1 << 3) | (1 << 4), 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅓ") {
      byte dots[3] = { 0, (1 << 1) | (1 << 2) | (1 << 4), 0 }; // dot 2, 3, 4
      printBraille(dots);
    }
    else if (str == "ㅗ") {
      byte dots[3] = { 0, (1 << 0) | (1 << 4) | (1 << 5), 0 }; // dot 1, 3, 6
      printBraille(dots);
    }
    else if (str == "ㅣ") {
      byte dots[3] = { 0, (1 << 0) | (1 << 3) | (1 << 4), 0 }; // dot 1, 3, 5
      printBraille(dots);
    }
    else if (str == "ㅐ") {
      byte dots[3] = { 0, (1 << 0) | (1 << 2) | (1 << 3) | (1 << 4), 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅚ") {
      byte dots[3] = { 0, (1 << 0) | (1 << 1) | (1 << 3) | (1 << 4) | (1 << 5), 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅠ") {
      byte dots[3] = { 0, (1 << 0) | (1 << 1) | (1 << 5), 0 }; 
      printBraille(dots);
    }
    else if (str == "ㅡ") {
      byte dots[3] = { 0, (1 << 1) | (1 << 2) | (1 << 5), 0 }; 
      printBraille(dots);
    }
    else if (str == "가") {
      byte dots[3] = { (1 << 0) | (1 << 1) | (1 << 2) | (1 << 5), 0, 0 };
      printBraille(dots);
    }
    else if (str == "나") {
      byte dots[3] = { (1 << 0) | (1 << 1), 0, 0 }; // dot 1, 4
      printBraille(dots);
    }
    else if (str == "사과") {
      byte dots[3] = {
        (1 << 0) | (1 << 2) | (1 << 4),             // 모듈 0 (오른쪽 셀): dot 0, 2, 4
        (1 << 1),                                   // 모듈 1 (가운데 셀): dot 1
        (1 << 0) | (1 << 2) | (1 << 4) | (1 << 5)    // 모듈 2 (왼쪽 셀): dot 0, 2, 4, 5
      };
      printBraille(dots);
    }
    else if (str == "바나나") {
      byte dots[3] = {
        (1 << 1) | (1 << 3),            
        (1 << 0) | (1 << 1),                                   
        (1 << 0) | (1 << 1)    
      };
      printBraille(dots);
    }
    else if (str == "감자") {
      byte dots[3] = {
        (1 << 0) | (1 << 1) | (1 << 2) | (1 << 5),            
        (1 << 2) | (1 << 5),                                   
        (1 << 1) | (1 << 5)    
      };
      printBraille(dots);
    }
    else if (str == "뱀") {
      byte dots[3] = {
        (1 << 1) | (1 << 3),                                   
        (1 << 0) | (1 << 2) | (1 << 4) | (1 << 3),            
        (1 << 2) | (1 << 5)    
      };
      printBraille(dots);
    }
    else if (str == "종이") {
      byte dots[3] = {
        (1 << 1) | (1 << 5),                                   
        (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3) | (1 << 4) | (1 << 5),            
        (1 << 0) | (1 << 3) | (1 << 4) 
      };
      printBraille(dots);
    }

    delay(500);
    clearBraille();
    Serial.println("✅ 점자 출력 완료");
  }
}

void printBraille(byte module0, byte module1, byte module2) {
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, LSBFIRST, module2);
  shiftOut(dataPin, clockPin, LSBFIRST, module1);
  shiftOut(dataPin, clockPin, LSBFIRST, module0);
  digitalWrite(latchPin, HIGH);
}

void printBraille(byte dots[3]) {
  printBraille(dots[0], dots[1], dots[2]);
}

void clearBraille() {
  printBraille(0x00, 0x00, 0x00);
}
