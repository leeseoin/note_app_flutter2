import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  int? id; // 각 노트들 마다 해당하는 id 값
  String? img; // 이미지 경로 저장 빌드
  String? title; // 제목
  late String content; // 내용
  DateTime? createdAt; // 생성 날자
  DateTime? updatedAt; // 수정 날짜

  Note({
    this.id,
    this.img,
    this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
