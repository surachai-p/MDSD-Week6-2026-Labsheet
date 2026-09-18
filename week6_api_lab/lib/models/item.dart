class Item {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl; // ในคลาสใช้ imageUrl แต่ใน JSON จะส่งมาเป็น image

  const Item({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      title: json['title'] as String,
      // แปลง price โดย cast ผ่าน num ก่อนเรียก .toDouble() เสมอเพื่อป้องกัน Error
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      // ดึงจาก key 'image' ใน JSON
      imageUrl: json['image'] as String, 
    );
  }
}