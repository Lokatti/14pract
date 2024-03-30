class Picture {
  final int pictureId;
  final String photoData;
  final DateTime uploadDate;

  Picture({
    required this.pictureId,
    required this.photoData,
    required this.uploadDate,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      pictureId: json['pictureId'],
      photoData: json['photoData'],
      uploadDate: DateTime.parse(json['uploadDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pictureId': pictureId,
      'photoData': photoData,
      'uploadDate': uploadDate.toIso8601String(),
    };
  }
}
