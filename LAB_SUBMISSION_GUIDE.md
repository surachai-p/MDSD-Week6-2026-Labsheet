# Week 6 — คู่มือทำใบงานและภาพหลักฐาน

ไฟล์นี้ใช้เป็นเช็กลิสต์ระหว่างทำใบงาน ส่วนคำตอบและรูปหลักฐานให้วางใน `week06_lab_v2_1.md` ตาม Checkpoint ที่ตรงกัน

> ห้ามใส่ OpenWeather API key จริงลง Git หรือภาพส่งงาน ให้ใช้ `YOUR_API_KEY` เมื่อเผยแพร่ภาพหรือโค้ด

## ก่อนเริ่ม

1. เปิดโฟลเดอร์ `week6_api_lab` ใน VS Code
2. เปิด Terminal แล้วรัน `flutter pub get`
3. สร้าง API key จาก OpenWeather และรันแอปโดยไม่บันทึก key ในไฟล์:

   ```powershell
   flutter run --dart-define=OPENWEATHER_API_KEY=ใส่_key_จริง_ที่นี่
   ```

4. โค้ดอ่าน key จาก `--dart-define` จึงไม่ต้องแก้หรือบันทึก key ลงไฟล์

## Checkpoint 1.1 — Postman สำเร็จ

ทำ:

1. ใน Postman ส่ง `GET` ไปที่ OpenWeather URL ของ Bangkok โดยใช้ API key จริง
2. ตรวจว่าด้านบนแสดง `200 OK`
3. เลื่อนให้เห็น Response Body ซึ่งมี `name`, `main.temp`, `main.feels_like`, และ `weather[0].description`

แคปภาพ:

- หน้าจอ Postman 1 ภาพที่เห็น method, URL (ปิดหรือแทน API key), `200 OK`, และ Response Body

บันทึกในใบงาน:

- อธิบาย key ทั้ง 4 ตัวข้างต้น

## Checkpoint 1.2 — Postman กรณีผิดพลาด

ทำ:

1. เปลี่ยน `q` เป็น `NonExistentCityXYZ999`
2. เขียนคำทำนายว่าได้ `404 Not Found` ก่อนกด Send
3. กด Send และตรวจ Response `404` กับข้อความ `city not found`

แคปภาพ:

- Postman ที่เห็น `404 Not Found` และ Response Body

บันทึกในใบงาน:

- ระบุว่าผลอยู่ในกลุ่ม `4xx Client Error` และผลตรง/ไม่ตรงกับที่คาด

## Checkpoint 2.1 — แปลง JSON เป็น Weather

ทำ:

1. วาง Response JSON จริงจาก Postman ลงใน `lib/test_weather_parse.dart`
2. รัน:

   ```powershell
   dart run lib/test_weather_parse.dart
   ```

3. ตรวจค่าที่ print: `cityName`, `temperature`, `description`, `feelsLike`

แคปภาพ:

- Terminal หรือ Debug Console ที่เห็นคำสั่งและค่าทั้ง 4 ฟิลด์

## Checkpoint 2.2 — ตรวจ status code ด้วย http

ทำ:

1. รันไฟล์ทดสอบจากโฟลเดอร์ `week6_api_lab`:

   ```powershell
   dart run -DOPENWEATHER_API_KEY=ใส่_key_จริง_ที่นี่ lib/test_weather_service.dart
   ```

2. ไฟล์จะทดสอบ Bangkok (200) และ `NonExistentCityXYZ999` (404) ต่อเนื่องกัน

แคปภาพ:

- Terminal ที่เห็นผลการทดสอบทั้ง `200 OK` และ `404 Not Found`

## Checkpoint 2.3 — สถานะหน้าจอ 3 แบบ

แคปภาพให้ครบ 3 ภาพ:

1. ระหว่างกดค้นหา: loading spinner
2. ค้นหาเมืองจริง: ชื่อเมือง อุณหภูมิ และคำอธิบาย
3. ปิด Wi-Fi/Data แล้วค้นหา: ข้อความ error

## Checkpoint 3.1 — HTTP POST

ทำ:

1. จากโฟลเดอร์ `week6_api_lab` รัน:

   ```powershell
   dart run lib/test_demo_post.dart
   ```

2. ส่วนแรกของผลลัพธ์ต้องมี `Checkpoint 3.1: POST Result`, `Status Code: 201` และ Response Body

แคปภาพ:

- Terminal ที่เห็น status code และ Response Body ของ POST

## Checkpoint 3.2 — HTTP PUT

ทำ:

1. ใช้ผลลัพธ์ส่วนที่สองจากคำสั่ง `dart run lib/test_demo_post.dart`
2. ต้องมี `Checkpoint 3.2: PUT Result`, `Status Code: 200` และ Response Body

แคปภาพ:

- Terminal ที่เห็น status code และ Response Body ของ PUT ซึ่งมีรหัส/ชื่อนักศึกษา

## Checkpoint 4.2 — Fake Store API จาก AI

ทำ:

1. รัน:

   ```powershell
   dart run lib/test_ai_product.dart
   ```

2. ตรวจว่ารายการสินค้าถูก print ออกมา

แคปภาพ:

- Terminal หรือ Debug Console ที่เห็นสินค้าจริงอย่างน้อยหลายรายการ

บันทึกเพิ่มเติมในใบงาน (4.1):

- ถ้าไม่พบข้อผิดพลาด ให้เขียนว่า “ไม่พบ error หลังตรวจ import, type และ field ของ JSON”
- หากแก้ error ให้บันทึก error ที่พบและวิธีแก้จริง

## Checkpoint 5.1–5.3 — Dio

ทำ:

1. ใช้ API key ผ่าน `--dart-define` (ไม่ต้องแก้ไฟล์ Dio)
2. รัน `dart run -DOPENWEATHER_API_KEY=ใส่_key_จริง_ที่นี่ lib/test_weather_dio.dart`

แคปภาพ:

- ผลลัพธ์ 4 ฟิลด์จาก Dio

คำตอบ 5.2 ที่ต้องเขียนเอง (อย่างน้อย 3 ประเด็น):

- Dio แปลง JSON response เป็น object ให้ ส่วน http ต้อง `jsonDecode()` เอง
- Dio ส่ง query parameters ผ่าน `queryParameters` ส่วน http ประกอบผ่าน `Uri`
- Dio รวม error เครือข่ายไว้ใน `DioException` ส่วน http แยก `TimeoutException`, `ClientException` และ `FormatException`

สำหรับ 5.3 ให้วางโค้ดดัก `receiveTimeout` และ `connectionError` จากไฟล์ Dio ในใบงาน

## Checkpoint 7.1 และ 7.3

ส่วนนี้อ้างอิงโครงงาน Campus Marketplace ของสัปดาห์ 5 ซึ่งยังไม่มีในโฟลเดอร์ปัจจุบัน จึงต้องนำไฟล์ `Product/CartModel/HomePage/CheckoutPage` จากงานสัปดาห์ 5 มาไว้ในโปรเจกต์ก่อน

เมื่อมีโครงงานแล้ว:

1. สร้าง `Item` จาก JSON และรัน `lib/test_item_parse.dart` — แคปผลทั้ง 6 ฟิลด์ (7.1)
2. สร้าง `ItemRepository` และ `ItemRepositoryApi` — แคปโครงสร้างไฟล์ให้เห็นทั้งสองไฟล์
3. แก้ HomePage ให้รับ repository ผ่าน constructor และแสดงรายการจาก API — แคปหน้าสินค้าจริง พร้อมปุ่มเพิ่มตะกร้าและหน้า Checkout ที่ยังใช้ได้ (7.3)

## ก่อนส่ง

- [ ] รูปทุกภาพถูกวางใต้ Checkpoint ที่ถูกต้องใน `week06_lab_v2_1.md`
- [ ] ไม่มี API key จริงใน Markdown, source code หรือภาพ
- [ ] โค้ดรันได้ด้วย `flutter analyze` และ `flutter test`
- [ ] ไม่แตะต้องไฟล์โค้ดของสัปดาห์ 5 นอกจากเปลี่ยน type จาก `Product` เป็น `Item` ตามโจทย์
