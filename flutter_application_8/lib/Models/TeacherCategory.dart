class TeacherCategory {
  final int teacherCategoryId; // Обновленное определение поля
  final String teacherCategoryName;

  TeacherCategory({
    required this.teacherCategoryId,
    required this.teacherCategoryName,
     // Обновленный аргумент конструктора
  });

  factory TeacherCategory.fromJson(Map<String, dynamic> json) {
    return TeacherCategory(
      teacherCategoryId: json['teacherCategoryId'], // Обновленное использование ключа
      teacherCategoryName: json['teacherCategoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherCategoryId': teacherCategoryId, // Обновленное использование ключа
      'teacherCategoryName': teacherCategoryName,
    };
  }
}
