class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      title: (json['title'] as String? ?? '').trim(),
      body: (json['body'] as String? ?? '').trim(),
    );
  }

  static List<Post> fromJsonList(List<dynamic> list) =>
      list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
}
