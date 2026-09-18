class Item {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;

  const Item({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    // ตัวอย่าง: ดึงค่า id, title และ price (price ต้อง cast ผ่าน num ก่อนเรียก .toDouble())
    final id = json['id'] as int;
    final title = json['title'] as String;
    final price = (json['price'] as num).toDouble();

    // ดึงค่า description และ category ด้วยวิธีเดียวกับ title
    final description = json['description'] as String;
    final category = json['category'] as String;

    // ดึง imageUrl จาก key 'image' ใน JSON (ชื่อ key ไม่ตรงกับชื่อฟิลด์ในคลาส)
    final imageUrl = json['image'] as String;

    return Item(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      imageUrl: imageUrl,
    );
  }

  @override
  String toString() {
    return 'Item(\n'
        '  id: $id,\n'
        '  title: $title,\n'
        '  price: $price,\n'
        '  description: $description,\n'
        '  category: $category,\n'
        '  imageUrl: $imageUrl,\n'
        ')';
  }
}