import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// ============================================================================
// 1. Model class: AiProduct
// ============================================================================
class AiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  AiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  /// Factory constructor สำหรับแปลง Map<String, dynamic> จาก JSON
  ///
  /// [เหตุผลที่ต้อง cast ตัวเลขผ่าน num แล้วเรียก .toDouble()]:
  /// ภาษา Dart เป็นภาษาแบบ statically typed ที่เข้มงวดมาก หากเขียน `json['price'] as double`
  /// แต่ทางเซิร์ฟเวอร์ส่งค่าที่เป็นเลขจำนวนเต็มกลับมา เช่น 109 หรือ 50 (ซึ่ง Dart จะ parse เป็น int)
  /// ระบบจะ throw TypeError: "int is not a subtype of type double" ทำให้แอป crash ทันที
  /// เนื่องจากทั้ง int และ double เป็นคลาสลูกของ `num` ใน Dart ดังนั้นการแปลงผ่าน
  /// `(json['price'] as num?)?.toDouble() ?? 0.0` จึงเป็นวิธีที่ปลอดภัยที่สุด
  /// รองรับได้ทั้งค่า int และ double โดยไม่เกิดข้อผิดพลาดขณะรันไทม์
  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      // Cast ผ่าน num แล้วเรียก .toDouble() เสมอตามข้อกำหนด
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}

// ============================================================================
// 2. ฟังก์ชันดึงรายการสินค้าทั้งหมด: fetchAiProducts()
// ============================================================================
/// ดึงรายการสินค้าทั้งหมดจาก GET https://fakestoreapi.com/products
/// - คืนค่าเป็น Future<List<AiProduct>>
/// - มี timeout ไม่เกิน 10 วินาที
Future<List<AiProduct>> fetchAiProducts() async {
  final url = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http
        .get(url)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            // [จุด error: onTimeout callback]
            // อธิบาย: เกิดขึ้นเมื่อการรอคอยการเชื่อมต่อหรือการรับส่งแพ็กเก็ตข้อมูลจากเซิร์ฟเวอร์
            // ใช้เวลาเกิน 10 วินาทีที่กำหนดไว้ เราโยน TimeoutException ออกไปเพื่อให้ตกบล็อก catch เฉพาะ
            throw TimeoutException('หมดเวลาเชื่อมต่อกับเซิร์ฟเวอร์');
          },
        );

    // [จุด error: HTTP Status Code Check]
    // อธิบาย: ตรวจสอบสถานะการตอบรับจาก Web Server
    // แม้จะไม่มี network error แต่เซิร์ฟเวอร์อาจตอบกลับด้วยรหัสล้มเหลว เช่น 404 Not Found หรือ 500 Internal Error
    if (response.statusCode == 200) {
      final dynamic decodedData = jsonDecode(response.body);

      // [จุด error: โครงสร้าง JSON]
      // อธิบาย: ป้องกันกรณีที่ Endpoint ส่งข้อมูลผิดรูปแบบ เช่น ส่ง Object เดี่ยว หรือข้อความอื่นมาแทนที่จะเป็น Array
      if (decodedData is List) {
        return decodedData
            .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException(
          'โครงสร้างข้อมูลไม่ถูกต้อง คาดหวังรูปแบบ Array รายการสินค้า',
        );
      }
    } else {
      throw Exception(
        'เซิร์ฟเวอร์เกิดข้อผิดพลาด (รหัสสถานะ: ${response.statusCode}) กรุณาลองใหม่อีกครั้ง',
      );
    }
  } on TimeoutException {
    // [ทำไมต้องดักจับ TimeoutException]:
    // เกิดขึ้นเมื่อผู้ใช้ใช้งานในพื้นที่ที่สัญญาณอินเทอร์เน็ตหน่วงมาก (High Latency) จนเกินกำหนด 10 วินาที
    // หากไม่ดักจับตรงนี้ แอปจะค้างอยู่ในสถานะรอคอยตลอดไป และระบบจะแสดง Unhandled Exception
    // การดักจับทำให้เราแจ้งเตือนผู้ใช้ด้วยภาษาไทยให้ลองใหม่อีกครั้งได้อย่างสุภาพ
    throw Exception(
      'การเชื่อมต่อหมดเวลา (เกิน 10 วินาที) กรุณาตรวจสอบความเร็วอินเทอร์เน็ตแล้วลองใหม่อีกครั้ง',
    );
  } on http.ClientException {
    // [ทำไมต้องดักจับ http.ClientException]:
    // เป็น Exception หลักของแพ็กเกจ http เมื่ออุปกรณ์ไม่สามารถส่ง HTTP Request ไปยังโฮสต์ปลายทางได้
    // เช่น ปิด Wi-Fi/เน็ตมือถือ, DNS Lookup ล้มเหลว (ค้นหา IP ของ fakestoreapi.com ไม่เจอ)
    // หากปล่อยข้อความดิบมาจากระบบ ผู้ใช้จะเห็น "ClientException: Failed to connect..." ที่เข้าใจยาก
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณหรือการเชื่อมต่อเครือข่าย',
    );
  } on SocketException {
    // [ทำไมต้องดักจับ SocketException]:
    // ในอุปกรณ์ Android/iOS ระดับ native หากเครื่องออฟไลน์สนิท ระบบเครือข่ายระดับ socket ของ Dart I/O
    // อาจพ่น SocketException ออกมาก่อนที่จะถูกห่อหุ้ม การดักจับจุดนี้จึงรับประกันว่าครอบคลุมการออฟไลน์ 100%
    throw Exception(
      'ไม่สามารถติดต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของคุณ',
    );
  } on FormatException {
    // [ทำไมต้องดักจับ FormatException]:
    // เกิดขึ้นได้ 2 กรณี:
    // 1. jsonDecode() ล้มเหลว เช่น เซิร์ฟเวอร์พังแล้วส่งหน้าเว็บ HTML Error 502 Bad Gateway กลับมาแทน JSON
    // 2. ข้อมูลที่ถอดรหัสออกมาไม่ตรงกับ Type ที่คาดหวัง
    // การดักจับจุดนี้ช่วยแปลงเป็นข้อความภาษาไทยแจ้งว่าข้อมูลไม่ถูกต้อง โดยไม่ต้องให้แอป crash
    throw Exception(
      'ข้อมูลที่ได้รับจากเซิร์ฟเวอร์มีรูปแบบไม่ถูกต้อง กรุณาติดต่อผู้พัฒนา',
    );
  } catch (e) {
    // [ทำไมต้องดักจับ catch (e) ทั่วไป]:
    // ทำหน้าที่เป็น safety net ด่านสุดท้าย ดักจับ error แปลกปลอมอื่นๆ ที่ไม่ได้คาดคิดล่วงหน้า
    // เพื่อให้ฟังก์ชันไม่มีวันหลุด Unhandled Exception จนทำให้แอปพลิเคชันปิดตัวกะทันหัน
    throw Exception(
      'เกิดข้อผิดพลาดในการโหลดข้อมูลสินค้า กรุณาลองใหม่อีกครั้งในภายหลัง',
    );
  }
}

// ============================================================================
// 3. ฟังก์ชันดึงสินค้าชิ้นเดียวตาม ID: fetchAiProductById(int id)
// ============================================================================
/// ดึงข้อมูลสินค้าชิ้นเดียวตามรหัส ID จาก GET https://fakestoreapi.com/products/{id}
/// - คืนค่าเป็น Future<AiProduct> รายการเดียว
/// - มี timeout ไม่เกิน 10 วินาที
/// - จัดการ error ครอบคลุม TimeoutException, ClientException, FormatException แปลงเป็นภาษาไทย
Future<AiProduct> fetchAiProductById(int id) async {
  final url = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http
        .get(url)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            // [จุด error: onTimeout callback]
            // อธิบาย: ดักจับกรณีรอเซิร์ฟเวอร์ส่งข้อมูลสินค้าชิ้นนี้นานเกิน 10 วินาที
            throw TimeoutException('หมดเวลาเชื่อมต่อกับเซิร์ฟเวอร์');
          },
        );

    // [จุด error: HTTP Status Code Check]
    // อธิบาย: เช็คว่าเซิร์ฟเวอร์ตอบกลับมาว่าพบสินค้าชิ้นนี้หรือไม่
    if (response.statusCode == 200) {
      // หมายเหตุสำหรับ FakeStore API: หากส่ง ID ที่ไม่มีอยู่จริง (เช่น 999)
      // บางครั้งเซิร์ฟเวอร์ส่ง HTTP 200 แต่ body ส่งกลับมาเป็น "" หรือ "null"
      if (response.body.trim().isEmpty || response.body.trim() == 'null') {
        throw const FormatException('ไม่พบข้อมูลสินค้าชิ้นนี้ในระบบ');
      }

      final dynamic decodedData = jsonDecode(response.body);

      // [จุด error: ตรวจสอบความถูกต้องของ Object]
      // อธิบาย: ตรวจสอบว่าผลลัพธ์เป็น JSON Map<String, dynamic> รายการเดียว (ไม่ใช่ List และไม่ใช่ primitive)
      if (decodedData is Map<String, dynamic>) {
        return AiProduct.fromJson(decodedData);
      } else {
        throw const FormatException(
          'โครงสร้างข้อมูลไม่ถูกต้อง คาดหวังรูปแบบข้อมูลสินค้าชิ้นเดียว',
        );
      }
    } else if (response.statusCode == 404) {
      // [จุด error: จัดการกรณี 404 Not Found]
      // อธิบาย: แปลงรหัส 404 เป็นภาษาไทยที่ชัดเจนว่าไม่พบสินค้ารหัสนี้
      throw Exception('ไม่พบข้อมูลสินค้ารหัส $id ในระบบ (รหัสสถานะ: 404)');
    } else {
      // [จุด error: จัดการกรณี 500, 502 หรือสถานะล้มเหลวอื่นๆ]
      throw Exception(
        'เซิร์ฟเวอร์เกิดข้อผิดพลาด (รหัสสถานะ: ${response.statusCode}) กรุณาลองใหม่อีกครั้ง',
      );
    }
  } on TimeoutException {
    // [ทำไมต้องดักจับ TimeoutException]:
    // ดักจับเมื่อการเรียกหาสินค้ารหัสนี้ใช้เวลาเกิน 10 วินาที เช่น สัญญาณอินเทอร์เน็ตขาดหายระหว่างรับส่ง
    // ช่วยป้องกันไม่ให้หน้ารายละเอียดสินค้าหมุนติ้วไม่สิ้นสุด
    throw Exception(
      'การเชื่อมต่อหมดเวลา (เกิน 10 วินาที) กรุณาตรวจสอบความเร็วอินเทอร์เน็ตแล้วลองใหม่อีกครั้ง',
    );
  } on http.ClientException {
    // [ทำไมต้องดักจับ http.ClientException]:
    // ดักจับเมื่อเครื่องผู้ใช้ไม่มีการเชื่อมต่อเครือข่าย (Offline) หรือ DNS ค้นหาโฮสต์ปลายทางไม่พบ
    // แปลงเป็นภาษาไทยแจ้งเตือนผู้ใช้ให้ตรวจเช็คเน็ตหรือ Wi-Fi
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณหรือการเชื่อมต่อเครือข่าย',
    );
  } on SocketException {
    // [ทำไมต้องดักจับ SocketException]:
    // ดักจับข้อผิดพลาดระดับ socket connection บนระบบปฏิบัติการมือถือ (Android/iOS) เมื่อออฟไลน์
    throw Exception(
      'ไม่สามารถติดต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของคุณ',
    );
  } on FormatException {
    // [ทำไมต้องดักจับ FormatException]:
    // ดักจับเมื่อข้อมูลที่เซิร์ฟเวอร์ตอบกลับมาไม่ได้เป็นรูปแบบ JSON ที่ถูกต้อง หรือไม่พบข้อมูลตามโครงสร้างที่โมเดล AiProduct ต้องการ
    throw Exception(
      'ข้อมูลที่ได้รับจากเซิร์ฟเวอร์มีรูปแบบไม่ถูกต้อง กรุณาติดต่อผู้พัฒนา',
    );
  } catch (e) {
    // [ทำไมต้องดักจับ catch (e) ทั่วไป]:
    // ทำหน้าที่เป็น safety net ด่านสุดท้าย ดักจับ error ไม่คาดคิดอื่นๆ ทั้งหมด เพื่อความปลอดภัยสูงสุดของแอป
    throw Exception(
      'เกิดข้อผิดพลาดในการโหลดข้อมูลสินค้ารหัส $id กรุณาลองใหม่อีกครั้งในภายหลัง',
    );
  }
}
