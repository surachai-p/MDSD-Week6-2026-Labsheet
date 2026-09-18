import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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

  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: json['id'] as int,
      title: json['title'] as String,
      // ป้องกัน Error หาก API ส่งเลขจำนวนเต็มมา แทนที่จะเป็นทศนิยม
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

// --- ฟังก์ชันดึงข้อมูลสินค้าตัวเดียวตาม ID ---
Future<AiProduct> fetchAiProductById(int id) async {
  final url = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      // สำหรับสินค้าตัวเดียว API คืนค่าเป็น Map { ... } ไม่ใช่ List [ ... ]
      final Map<String, dynamic> body = jsonDecode(response.body);
      return AiProduct.fromJson(body);
    } else {
      throw Exception('ไม่พบข้อมูลสินค้านี้ในระบบ (Error: ${response.statusCode})');
    }
  } on TimeoutException {
    /* 
       ทำไมต้องดักจับ: เพื่อป้องกันแอป "หมุนค้าง" นานเกินไปเมื่ออินเทอร์เน็ตช้ามาก 
       หรือเซิร์ฟเวอร์ไม่มีการตอบสนอง (No response) ภายในเวลาที่กำหนด
    */
    throw Exception('การเชื่อมต่อใช้เวลานานเกินไป กรุณาตรวจสอบอินเทอร์เน็ต');
  } on SocketException {
    /* 
       ทำไมต้องดักจับ: เกิดขึ้นเมื่อเครื่องผู้ใช้ "ไม่มีการเชื่อมต่ออินเทอร์เน็ต" เลย 
       (เช่น ปิดเน็ต, อยู่ในโหมดเครื่องบิน) หรือไม่สามารถหาเลข IP ของ Server ได้ (DNS Fail)
    */
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
  } on http.ClientException {
    /* 
       ทำไมต้องดักจับ: เกิดปัญหาในระดับ HTTP Client เช่น การส่ง Request ผิดพลาด, 
       การเชื่อมต่อถูกตัดกลางคัน (Connection closed) หรือปัญหา SSL Certificate
    */
    throw Exception('เกิดข้อผิดพลาดในการรับ-ส่งข้อมูลกับเซิร์ฟเวอร์');
  } on FormatException {
    /* 
       ทำไมต้องดักจับ: เกิดขึ้นเมื่อ jsonDecode ทำงานไม่สำเร็จ เช่น เซิร์ฟเวอร์ล่มแล้วส่งค่า
       เป็นหน้าเว็บ HTML Error กลับมาแทนที่จะเป็น JSON ทำให้แอปประมวลผลต่อไม่ได้
    */
    throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง ไม่สามารถแสดงผลได้');
  } catch (e) {
    /* 
       ทำไมต้องดักจับ: เป็น Safety Net สำหรับกรณีอื่นๆ ที่คาดไม่ถึง 
       เช่น Error ภายในตัว Model หรือการ Map ข้อมูลผิดพลาด
    */
    throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ: ${e.toString()}');
  }
}

// --- ฟังก์ชันดึงข้อมูลสินค้าทั้งหมด (จากข้อก่อนหน้า) ---
Future<List<AiProduct>> fetchAiProducts() async {
  final url = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => AiProduct.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('ไม่สามารถดึงรายการสินค้าได้ (Error: ${response.statusCode})');
    }
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on SocketException {
    throw Exception('อินเทอร์เน็ตขัดข้อง กรุณาตรวจสอบ Wi-Fi หรือเน็ตมือถือ');
  } on http.ClientException {
    throw Exception('เซิร์ฟเวอร์ปลายทางมีปัญหา ไม่สามารถติดต่อได้');
  } on FormatException {
    throw Exception('โครงสร้างข้อมูลผิดพลาด ไม่สามารถประมวลผลรายการได้');
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาด: ${e.toString()}');
  }
}

