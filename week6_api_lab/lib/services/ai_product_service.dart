import 'dart:async';
import 'dart:convert';
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
      title: json['title'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

Future<List<AiProduct>> fetchAiProducts() async {
  final Uri url = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      /*
       * [ทำไมต้องดักจับ Status Code นอกเหนือจาก 200]:
       * เพราะการร้องขอ (Request) ส่งไปถึงเซิร์ฟเวอร์สำเร็จ แต่เซิร์ฟเวอร์ปฏิเสธการประมวลผล
       * หรือมีข้อผิดพลาดฝั่งเซิร์ฟเวอร์ (เช่น 404 Not Found หรือ 500 Internal Server Error)
       * จึงต้องดักจับเพื่อแยกแยะระหว่าง "เน็ตหลุด" กับ "เซิร์ฟเวอร์มีปัญหา"
       */
      throw Exception('เซิร์ฟเวอร์ขัดข้อง กรุณาลองใหม่อีกครั้งในภายหลัง (รหัส: ${response.statusCode})');
    }
  } on TimeoutException {
    /*
     * [ทำไมต้องดักจับ TimeoutException โดยเฉพาะ]:
     * เกิดขึ้นเมื่อเซิร์ฟเวอร์ตอบสนองช้ากว่า 10 วินาทีที่กำหนดไว้
     * สาเหตุอาจเกิดจากเซิร์ฟเวอร์โหลดหนัก หรือสัญญาณอินเทอร์เน็ตผู้ใช้ค้าง/หน่วงมาก
     * การดักจับแยกช่วยให้แจ้งผู้ใช้ได้ตรงจุดว่า "หมดเวลาเชื่อมต่อ" เพื่อให้กดลองใหม่
     */
    throw Exception('การเชื่อมต่อใช้เวลานานเกินไป กรุณาตรวจสอบอินเทอร์เน็ตแล้วลองใหม่อีกครั้ง');
  } on http.ClientException {
    /*
     * [ทำไมต้องดักจับ http.ClientException โดยเฉพาะ]:
     * เกิดขึ้นจากความผิดพลาดในระดับอุปกรณ์ไคลเอนต์ เช่น ผู้ใช้ไม่ได้เปิดอินเทอร์เน็ต (SocketException),
     * DNS ไม่สามารถค้นหาชื่อโดเมนได้ หรือการเชื่อมต่อถูกตัดขาดระหว่างส่งข้อมูล
     * การดักจับแยกช่วยระบุได้ชัดเจนว่าเป็นปัญหาจาก "อินเทอร์เน็ตของผู้ใช้งาน"
     */
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณเน็ตของคุณ');
  } on FormatException {
    /*
     * [ทำไมต้องดักจับ FormatException โดยเฉพาะ]:
     * เกิดขึ้นเมื่อ jsonDecode() ล้มเหลว เนื่องจากข้อความที่ได้รับไม่ใช่โครงสร้าง JSON ที่ถูกต้อง
     * (เช่น เซิร์ฟเวอร์ส่งหน้าเว็บ HTML Error กลับมาแทนที่จะเป็น JSON)
     * การดักจับแยกช่วยให้ทราบว่าปัญหามารูปแบบข้อมูลที่เซิร์ฟเวอร์ส่งมาไม่ถูกต้อง
     */
    throw Exception('ข้อมูลที่ได้รับจากระบบมีรูปแบบไม่ถูกต้อง');
  } catch (e) {
    /*
     * [ทำไมต้องดักจับ catch (e) ทั่วไป]:
     * ป้องกันข้อผิดพลาดอื่นๆ ที่ไม่ได้คาดการณ์ไว้ล่วงหน้า (เช่น Type Mismatch หรือ Null Pointer)
     * ไม่ให้ส่งผลกระทบทำให้แอปพลิเคชัน Crash หรือหยุดการทำงานโดยไม่แจ้งเตือนผู้ใช้
     */
    if (e is Exception && e.toString().startsWith('Exception: ')) {
      rethrow;
    }
    throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  final Uri url = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      // ตรวจสอบกรณีที่ API คืนค่าเป็น String ว่างเปล่า หรือข้อความ 'null' (เช่น ส่ง id ที่ไม่มีในระบบไป)
      if (response.body.isEmpty || response.body == 'null') {
        throw Exception('ไม่พบข้อมูลสินค้ารายการนี้ในระบบ');
      }

      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return AiProduct.fromJson(jsonMap);
    } else {
      /*
       * [ทำไมต้องดักจับ Status Code นอกเหนือจาก 200]:
       * เพื่อรับมือกับ HTTP Error ที่เซิร์ฟเวอร์ตอบกลับมา เช่น รหัส 404 (ไม่พบสินค้าตาม ID นี้) 
       * หรือ 500 (เซิร์ฟเวอร์ล่ม) เพื่อแปลงเป็นข้อความภาษาไทยให้ผู้ใช้เข้าใจง่าย
       */
      throw Exception('เซิร์ฟเวอร์ขัดข้อง กรุณาลองใหม่อีกครั้งในภายหลัง (รหัส: ${response.statusCode})');
    }
  } on TimeoutException {
    /*
     * [ทำไมต้องดักจับ TimeoutException โดยเฉพาะ]:
     * ดักจับกรณีดึงข้อมูลสินค้ารายชิ้นแล้วใช้เวลานานเกิน 10 วินาที 
     * เพื่อบอกผู้ใช้ให้ชัดเจนว่าระบบหมดเวลารอคอย (Timeout) ไม่ใช่ข้อมูลไม่มี
     */
    throw Exception('การเชื่อมต่อใช้เวลานานเกินไป กรุณาตรวจสอบอินเทอร์เน็ตแล้วลองใหม่อีกครั้ง');
  } on http.ClientException {
    /*
     * [ทำไมต้องดักจับ http.ClientException โดยเฉพาะ]:
     * ดักจับปัญหาเกี่ยวกับเครือข่ายฝั่งมือถือ/เครื่องไคลเอนต์โดยตรง เช่น มือถือไม่ได้ต่อ Wi-Fi/Cellular
     * ช่วยให้แจ้งผู้ใช้ได้ทันทีว่าให้ไปเช็คการเชื่อมต่อเน็ตของตนเอง
     */
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณเน็ตของคุณ');
  } on FormatException {
    /*
     * [ทำไมต้องดักจับ FormatException โดยเฉพาะ]:
     * ดักจับกรณีข้อความที่ตอบกลับมาไม่สามารถแปลงเป็น JSON Map ได้ 
     * เพื่อป้องกันปัญหาแอป Crash จากการ parse ข้อมูลที่ผิดรูปแบบ
     */
    throw Exception('ข้อมูลที่ได้รับจากระบบมีรูปแบบไม่ถูกต้อง');
  } catch (e) {
    /*
     * [ทำไมต้องดักจับ catch (e) ทั่วไป]:
     * เซฟการทำงานในขั้นตอนสุดท้าย เพื่อเก็บตกข้อผิดพลาดที่คาดไม่ถึง 
     * เช่น ปัญหา Type Casting ภายในตัว Model AiProduct.fromJson
     */
    if (e is Exception && e.toString().startsWith('Exception: ')) {
      rethrow;
    }
    throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง');
  }
}