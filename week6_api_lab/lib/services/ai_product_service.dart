// ============================================================================
// File: lib/services/ai_product_service.dart
// คำอธิบาย: บริการเรียก FakeStore REST API สำหรับโปรเจกต์ Flutter
// ประกอบด้วย:
//   1. Model class: AiProduct พร้อม fromJson / toJson ที่แปลงตัวเลขปลอดภัย 100%
//   2. ฟังก์ชัน fetchAiProducts() ดึงรายการสินค้าทั้งหมด (List)
//   3. ฟังก์ชัน fetchAiProductById(id) ดึงสินค้ารายการเดียว
//   4. ตั้ง Timeout 10 วินาที พร้อมจัดการ Error เป็นภาษาไทยและคอมเมนต์เหตุผลครบถ้วน
//
// ข้อกำหนด dependencies ใน pubspec.yaml:
// dependencies:
//   flutter:
//     sdk: flutter
//   http: ^1.2.0
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// ============================================================================
/// 1. Model class ชื่อ AiProduct
/// ============================================================================
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

  /// Factory constructor แปลง JSON Map เป็น Dart Object
  /// [หลักการสำคัญ]: ต้อง cast ตัวเลขผ่าน num แล้วเรียก .toDouble() เสมอ
  /// [ทำไมต้องทำเช่นนี้]:
  ///   - หาก FakeStore API ส่งราคาเป็น 109.95 Dart จะ parse เป็น double
  ///   - หาก API ส่ง 100 (จำนวนเต็ม) Dart จะ parse ออกมาเป็น int
  ///   - ถ้าเขียน json['price'] as double จะเกิดข้อผิดพลาดรุนแรงทันที:
  ///     "type 'int' is not a subtype of type 'double' in type cast"
  ///   - ใน Dart คลาส num เป็นคลาสแม่ของทั้ง int และ double
  ///     ดังนั้น (json['price'] as num?)?.toDouble() ?? 0.0 จึงปลอดภัย 100%
  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  /// แปลง Object กลับเป็น Map<String, dynamic>
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

  @override
  String toString() => 'AiProduct(id: $id, title: "$title", price: \$$price)';
}

/// ============================================================================
/// 2. ฟังก์ชัน fetchAiProducts() ดึงรายการสินค้าทั้งหมด
/// คืนค่าเป็น Future<List<AiProduct>>
/// ============================================================================
Future<List<AiProduct>> fetchAiProducts() async {
  final Uri uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    // ------------------------------------------------------------------------
    // ตั้ง timeout 10 วินาที:
    // [ทำไมต้องตั้ง]: ป้องกันไม่ให้แอปค้างหมุน loading ตลอดไปเมื่อเน็ตช้าหรือเซิร์ฟเวอร์แฮงค์
    // ------------------------------------------------------------------------
    final http.Response response = await http
        .get(
          uri,
          headers: {'Accept': 'application/json'},
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            // โยน TimeoutException เมื่อไม่มีการตอบกลับภายใน 10 วินาที
            throw TimeoutException('การเชื่อมต่อใช้เวลานานเกิน 10 วินาที');
          },
        );

    // ------------------------------------------------------------------------
    // ตรวจสอบ HTTP Status Code:
    // [ทำไมต้องตรวจสอบ]: แพ็กเกจ http จะไม่ throw exception อัตโนมัติเมื่อเจอ 4xx หรือ 5xx
    // หากไม่ตรวจสอบ statusCode แอปจะนำหน้าเว็บ HTML error ไป parse และเกิด FormatException ทันที
    // ------------------------------------------------------------------------
    if (response.statusCode == 200) {
      final dynamic decodedData = jsonDecode(response.body);

      // ตรวจสอบว่า Response ที่ได้เป็น List สินค้าจริงหรือไม่
      if (decodedData is List) {
        return decodedData
            .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException('ข้อมูลที่ได้รับไม่อยู่ในรูปแบบรายการสินค้า');
      }
    } else {
      throw HttpException(
        'เซิร์ฟเวอร์ขัดข้อง ไม่สามารถดึงข้อมูลได้ (รหัสสถานะ: ${response.statusCode})',
      );
    }
  }
  // ==========================================================================
  // จุดจัดการ Error พร้อมคอมเมนต์อธิบายเหตุผลการดักจับแต่ละชนิด:
  // ==========================================================================
  on TimeoutException {
    // [ทำไมต้องดักจับ TimeoutException]:
    // เกิดขึ้นเมื่อการเชื่อมต่อไปยัง API ใช้เวลาเกิน 10 วินาทีตามที่ตั้งไว้ใน .timeout()
    // สาเหตุ: เซิร์ฟเวอร์ต้นทางทำงานหนักจนค้าง หรือความเร็วอินเทอร์เน็ตของเครื่องผู้ใช้ต่ำมาก
    // การดักจับจุดนี้ทำให้แปลงเป็นข้อความภาษาไทยที่แนะนำให้ผู้ใช้ลองใหม่อีกครั้งได้
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาตรวจสอบสัญญาณอินเทอร์เน็ตแล้วลองใหม่อีกครั้ง');
  }
  on http.ClientException {
    // [ทำไมต้องดักจับ http.ClientException]:
    // โยนออกมาโดยตรงจากแพ็กเกจ http เมื่อฝั่ง Client ไม่สามารถส่ง HTTP Request ไปยังโฮสต์ได้
    // สาเหตุ: ผู้ใช้ไม่ได้เปิดอินเทอร์เน็ต, สัญญาณหลุดระหว่างส่ง, หรือ DNS Lookup ชื่อโดเมนล้มเหลว
    // ช่วยแยกแยะได้อย่างแม่นยำว่าปัญหามาจากฝั่งการเชื่อมต่อของเครื่องผู้ใช้เอง
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
  }
  on SocketException {
    // [ทำไมต้องดักจับ SocketException]:
    // บนอุปกรณ์จริง (iOS และ Android) เมื่อผู้ใช้เปิดโหมดเครื่องบิน (Airplane Mode)
    // หรือปิด Wi-Fi/Cellular ระบบปฏิบัติการระดับ Low-level OS จะโยน SocketException ขึ้นมาก่อน
    // การดักจับ SocketException ร่วมด้วยจะการันตีว่าแอปจะไม่แครชบนมือถือจริงแน่นอน
    throw Exception('ไม่สามารถเชื่อมต่อเครือข่ายได้ กรุณาตรวจสอบอินเทอร์เน็ตบนอุปกรณ์ของคุณ');
  }
  on FormatException {
    // [ทำไมต้องดักจับ FormatException]:
    // เกิดขึ้นเมื่อฟังก์ชัน jsonDecode ไม่สามารถแปลง String เป็น JSON ได้
    // สาเหตุ: เซิร์ฟเวอร์ตอบกลับเป็นหน้า HTML Error (เช่น Cloudflare 502 หรือ Nginx 404)
    // หรือ Response body มีอักขระแปลกปลอม/เสียหาย หรือโครงสร้างไม่ตรงตามสเปก
    // หากไม่ดักจับ แอปจะแครชในจังหวะ parse ข้อมูลทันที
    throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง ไม่สามารถประมวลผลได้');
  }
  catch (e) {
    // [ทำไมต้องมี catch ทั่วไป]:
    // ดักจับ HttpException ที่เราโยนไว้ใน else หรือ Exception อื่นๆ ที่หลุดรอดมา
    // เพื่อให้มั่นใจ 100% ว่าไม่มี Unhandled Exception หลุดไปทำให้แอปพัง
    if (e is Exception) {
      rethrow;
    }
    throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง');
  }
}

/// ============================================================================
/// 3. ฟังก์ชัน fetchAiProductById(int id) ดึงสินค้าชิ้นเดียวตาม ID
/// คืนค่าเป็น Future<AiProduct> รายการเดียว ไม่ใช่ List
/// ============================================================================
Future<AiProduct> fetchAiProductById(int id) async {
  final Uri uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    // ตั้ง timeout 10 วินาที
    final http.Response response = await http
        .get(
          uri,
          headers: {'Accept': 'application/json'},
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('การเชื่อมต่อใช้เวลานานเกิน 10 วินาที');
          },
        );

    // ตรวจสอบ HTTP Status Code
    if (response.statusCode == 200) {
      // FakeStore API มักส่ง body เปล่า ("" หรือ "null") เมื่อค้นหา ID ไม่เจอ
      if (response.body.isEmpty || response.body.trim() == 'null' || response.body.trim() == '') {
        throw const FormatException('ไม่พบข้อมูลสินค้าที่ระบุ');
      }

      final dynamic decodedData = jsonDecode(response.body);

      // สินค้าชิ้นเดียว decodedData ต้องเป็น Map<String, dynamic>
      if (decodedData is Map<String, dynamic>) {
        return AiProduct.fromJson(decodedData);
      } else {
        throw const FormatException('ข้อมูลที่ได้รับไม่อยู่ในรูปแบบรายละเอียดสินค้า');
      }
    } else if (response.statusCode == 404) {
      throw HttpException('ไม่พบสินค้ารหัส $id ในระบบ');
    } else {
      throw HttpException(
        'เซิร์ฟเวอร์ขัดข้อง ไม่สามารถดึงข้อมูลได้ (รหัสสถานะ: ${response.statusCode})',
      );
    }
  }
  // จุดจัดการ Error ครอบคลุมทุกกรณี พร้อมแปลงเป็นข้อความภาษาไทย
  on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาตรวจสอบสัญญาณอินเทอร์เน็ตแล้วลองใหม่อีกครั้ง');
  }
  on http.ClientException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
  }
  on SocketException {
    throw Exception('ไม่สามารถเชื่อมต่อเครือข่ายได้ กรุณาตรวจสอบอินเทอร์เน็ตบนอุปกรณ์ของคุณ');
  }
  on FormatException {
    throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง ไม่สามารถประมวลผลได้');
  }
  catch (e) {
    if (e is Exception) {
      rethrow;
    }
    throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง');
  }
}