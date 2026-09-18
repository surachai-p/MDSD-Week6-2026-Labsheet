# MDSD Week 6 - API Integration & Networking

## 📁 โครงสร้างของโปรเจกต์

ภายใน Repository นี้ประกอบไปด้วย 2 โปรเจกต์หลักที่อยู่ในโฟลเดอร์ `Lab/`:

### 1. `week6_api_lab` (แอปพลิเคชันค้นหาสภาพอากาศและทดสอบ API)

โปรเจกต์สำหรับฝึกฝนพื้นฐานการดึงและจัดการข้อมูลผ่านเครือข่าย ประกอบด้วยฟีเจอร์:

* **ค้นหาสภาพอากาศ:** ดึงข้อมูลสภาพอากาศจริงจาก **OpenWeather API** มาแสดงผล มีการจัดการสถานะ UI ครบถ้วน (Loading, Success, Error)
* **ทดสอบ HTTP Methods:** จำลองการส่งข้อมูลแบบ POST (สร้าง) และ PUT (แก้ไข) ไปยัง **JSONPlaceholder**
* **เปรียบเทียบ HTTP Clients:** มีตัวอย่างการเรียกใช้งาน API ที่เขียนด้วยแพ็กเกจ `http` มาตรฐาน เปรียบเทียบกับแพ็กเกจ `dio` ที่สามารถแปลง JSON ได้อัตโนมัติ
* **AI Code Generation:** ทดสอบนำร่องการดึงข้อมูลสินค้าจาก Fake Store API ด้วยโค้ดที่สร้างโดย AI

### 2. `campus_marketplace` (แอปพลิเคชันร้านค้าจำลอง)

โปรเจกต์หลักที่นำความรู้เรื่อง API มาประยุกต์ใช้ร่วมกับสถาปัตยกรรมซอฟต์แวร์:

* **Repository Pattern:** แยกส่วนติดต่อเครือข่าย (Interface/Implementation) ออกจากหน้า UI อย่างเด็ดขาด (`ItemRepository` และ `ItemRepositoryApi`)
* **Fake Store API:** ดึงรายการสินค้าจำลองจาก REST API จริงมาแสดงบนหน้าจอ
* **State Management:** ผสานการทำงานร่วมกับแพ็กเกจ `provider` เพื่อจัดการระบบ "ตะกร้าสินค้า" (Cart) ทำให้สามารถเพิ่มหรือลบสินค้าที่ดึงมาจาก API ได้อย่างสมบูรณ์

---

## ⚙️ วิธีการติดตั้งและรันโปรเจกต์

**1. โคลน Repository**

```bash
git clone https://github.com/USERNAME/MDSD-Week6-2026-Labsheet.git

```

**2. ตั้งค่า API Key สำหรับแอปสภาพอากาศ (`week6_api_lab`)**
เพื่อความปลอดภัย API Key จริงจะไม่ถูกบันทึกลงในคลังเก็บโค้ดนี้ ก่อนรันแอปพลิเคชันสภาพอากาศ คุณต้องแก้ไขไฟล์ต่อไปนี้:

* เข้าไปที่ `Lab/week6_api_lab/lib/services/weather_service.dart`
* เข้าไปที่ `Lab/week6_api_lab/lib/services/weather_service_dio.dart`
* ค้นหาคำว่า `'YOUR_API_KEY'` และแทนที่ด้วย API Key ที่ได้จากเว็บ OpenWeather

**3. ติดตั้ง Dependencies และรันแอป**
เนื่องจากมี 2 โปรเจกต์แยกกัน ให้เข้าโฟลเดอร์ของโปรเจกต์ที่ต้องการรันทีละตัว

*สำหรับโปรเจกต์ทดสอบ API:*

```bash
cd Lab/week6_api_lab
flutter pub get
flutter run

```

*สำหรับโปรเจกต์ Campus Marketplace:*

```bash
cd Lab/campus_marketplace
flutter pub get
flutter run

```

---
