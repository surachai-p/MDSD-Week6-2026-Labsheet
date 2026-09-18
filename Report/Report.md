# รายงานผลการปฏิบัติการ: ใบงานบทที่ 6 API Integration & Networking

**ชื่อ-นามสกุล :** พรพรม สุขใจมิตร

**รหัสนักศึกษา :** 67030323

---

## ส่วนที่ 1: ทดสอบ API ด้วย Postman

### ✅ Checkpoint 1.1: ทดสอบ GET Request สำเร็จ

- **รูปภาพ Postman (Status 200 และ Response Body):**
![alt text](/Report/img/image-1.png)

- **Key ใน JSON ที่คาดว่าจะต้องใช้แสดงผล:**
  1. ชื่อเมือง: ใช้ key `name`
  2. อุณหภูมิ: ใช้ key `main.temp`
  3. คำอธิบายสภาพอากาศ: ใช้ key `weather[0].description`

### ✅ Checkpoint 1.2: ทดสอบกรณีผิดพลาด (Error Case)

- **รูปภาพ Postman กรณี Error:**
![alt text](/Report/img/image-2.png)

- **กรณีที่เลือกทดสอบ:** แก้ไข/ลบตัวอักษรใน API Key (`appid`)
- **คาดการณ์ Status Code:** 401
- **Status Code จริงที่ได้:** 401 (ตรงตามที่คาดการณ์)
- **อธิบายผลลัพธ์:** สถานะ 401 จัดอยู่ในกลุ่ม Status Code 401 ซึ่งหมายถึงข้อผิดพลาดเกิดจากฝั่งแอป/ผู้ใช้ ในกรณีนี้คือการส่งข้อมูลยืนยันตัวตนไม่ถูกต้อง ทำให้เซิร์ฟเวอร์ปฏิเสธการเข้าถึง

---

## ส่วนที่ 2: สร้าง Model Class และเรียก API ด้วย http Package

### ✅ Checkpoint 2.1: ทดสอบการ Parse JSON (Weather Model)

- **รูปภาพหน้าจอ Debug Console:**
![alt text](/Report/img/image.png)

### ✅ Checkpoint 2.2: ตรวจสอบ Status Code ใน WeatherService

- **ผลการทดสอบเงื่อนไขสำเร็จ (200):** [พิมพ์อธิบายสั้นๆ ว่าทำงานได้ปกติ/ได้ออบเจกต์ Weather]
- **ผลการทดสอบเงื่อนไขไม่พบข้อมูล (404):** [พิมพ์อธิบายสั้นๆ ว่าโยน Exception ข้อมูลเมืองออกมาถูกต้อง]

### ✅ Checkpoint 2.3: ทดสอบแอป WeatherSearchPage 3 สถานการณ์

- **1. ค้นหาเมืองที่มีจริง:**
![alt text](/Report/img/image-3.png)

- **2. ค้นหาเมืองที่ไม่มีอยู่จริง:**
![alt text](/Report/img/image-4.png)

- **3. ปิด Wi-Fi/Data บนเครื่อง:**
![alt text](/Report/img/image-5.png)

---

## ส่วนที่ 3: ทดลองเรียก HTTP Method อื่นนอกเหนือจาก GET

### ✅ Checkpoint 3.1: ทดลอง HTTP POST (สร้างข้อมูลใหม่)

- **รูปภาพหน้าจอ Debug Console (Status Code 201):**
![alt text](/Report/img/image-6.png)

### ✅ Checkpoint 3.2: ทดลอง HTTP PUT (แก้ไขข้อมูล)

- **รูปภาพหน้าจอ Debug Console (Status Code 200):**
![alt text](/Report/img/image-7.png)

---

## ส่วนที่ 4: ใช้ AI ช่วย Generate โค้ด API Client

**บันทึก Error และการแก้ไข (ถ้ามี):**
[ไม่พบ Error โค้ดที่ AI สร้างให้สามารถใช้งาน ทำการ parse JSON และรันผ่านได้ทันที]

### ✅ Checkpoint 4.2: ผลลัพธ์จากการเรียก Fake Store API

- **รูปภาพหน้าจอ Debug Console (พิมพ์รายการสินค้าออกมา):**
![alt text](/Report/img/image-8.png)

---

## ส่วนที่ 5 (เพิ่มเติม): เปรียบเทียบกับ Dio Package

### ✅ Checkpoint 5.1: ผลลัพธ์การเรียก Weather API ด้วย Dio

- **รูปภาพหน้าจอ Debug Console / หน้าจอแอป:**
![alt text](/Report/img/image-9.png)

### ✅ Checkpoint 5.2: เปรียบเทียบ http กับ dio 3 ประเด็น

1. **การจัดการ JSON:** dio แปลงข้อมูล JSON เป็น Map ให้อัตโนมัติ แต่ http เราต้องเรียกใช้คำสั่ง jsonDecode เอง
2. **การกำหนด Query Parameters:** dio สามารถใส่พารามิเตอร์แยกเป็น Map ใน queryParameters ได้เลย ทำให้โค้ดสะอาด แต่ http เราต้องเอาตัวแปรมาต่อเป็น String ใน URL ด้วยตนเอง
3. **การจัดการ Exception:** dio จับรวบ Network Error ทุกรูปแบบไว้ในคลาสเดียวคือ DioException แล้วให้เราเช็คชนิดผ่าน .type แต่ http จะโยน Exception ออกมาหลายคลาสที่ต่างกัน

### ✅ Checkpoint 5.3: โค้ดเงื่อนไข DioExceptionType เพิ่มเติม

```dart
  on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } 
    // ส่วนที่เพิ่มในขั้นตอนที่ 5.4 
    else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('เซิร์ฟเวอร์ใช้เวลาตอบกลับนานเกินไป');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('ไม่สามารถเชื่อมต่อเครือข่ายได้ กรุณาตรวจสอบอินเทอร์เน็ต');
    }
    
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
```

---

## ส่วนที่ 7: ต่อยอดเข้าสู่โปรเจกต์ Campus Marketplace

### ✅ Checkpoint 7.1: ทดสอบ Item.fromJson()

- **รูปภาพหน้าจอ Debug Console (พิมพ์ค่า Item ออกมาทั้ง 6 ฟิลด์):**
![alt text](/Report/img/image-10.png)

### ✅ Checkpoint 7.3: หน้าจอ Home Page แบบสมบูรณ์

- **รูปภาพหน้าจอ Home (แสดงสินค้าจาก Fake Store API):**
![alt text](/Report/img/image-11.png)

- **รูปภาพโครงสร้างไฟล์ (เห็น item_repository.dart และ item_repository_api.dart):**
![alt text](/Report/img/image-12.png)

- **สถานะการทำงาน:** ปุ่มเพิ่มลงตะกร้า และระบบตะกร้า  สามารถทำงานร่วมกับ Item ชุดใหม่นี้ได้อย่างปกติ