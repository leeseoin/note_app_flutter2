import 'dart:convert';
import 'dart:io'; // File 클래스를 사용하기 위해
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart'; // ImagePicker 클래스를 사용하기 위해
import 'package:provider/provider.dart';
import 'package:note_app_flutter2/models/note_database.dart';
import 'package:note_app_flutter2/models/note.dart'; // Note 모델 import

class CreateOrUpdateNotePage extends StatefulWidget {
  final Note? note; // 수정 시 Note 객체를 받기 위해 nullable로 설정
  const CreateOrUpdateNotePage({super.key, this.note});

  @override
  _CreateOrUpdateNotePageState createState() {
    return _CreateOrUpdateNotePageState();
  }
}

class _CreateOrUpdateNotePageState extends State<CreateOrUpdateNotePage> {
  late final quill.QuillController _controller;
  final TextEditingController titleController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      debugPrint('Note content: ${widget.note!.content}');

      try {
        final contentJson = jsonDecode(widget.note!.content);
        _controller = quill.QuillController(
          document: quill.Document.fromJson(contentJson),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        debugPrint('Error decoding JSON content: $e');
        // 일반 텍스트로 처리
        _controller = quill.QuillController(
          document: quill.Document()..insert(0, widget.note!.content),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }

      titleController.text = widget.note!.title ?? '';

      if (widget.note!.img != null && widget.note!.img!.isNotEmpty) {
        _image = File(widget.note!.img!);
      }
    } else {
      _controller = quill.QuillController(
        document: quill.Document(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveNote() async {
    final title = titleController.text;
    final content = jsonEncode(_controller.document.toDelta().toJson());
    final img = _image?.path;

    if (!mounted) return;

    final noteDatabase = context.read<NoteDatabase>();

    try {
      if (widget.note != null) {
        // Update existing note
        await noteDatabase.updateNote(
          widget.note!.id!,
          title,
          content,
          img,
        );
      } else {
        // Create new note
        await noteDatabase.addNote(
          title,
          content,
          img,
        );
      }

      debugPrint('Saved note - Title: $title, Content: $content');

      // Navigate back to the previous screen
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error saving note: $e');
      // 여기에 사용자에게 오류를 표시하는 코드를 추가할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'Create Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 20),
            quill.QuillToolbar.simple(
              configurations: quill.QuillSimpleToolbarConfigurations(
                controller: _controller,
              ),
            ),
            Expanded(
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _controller,
                  placeholder: 'Start writing your note...',
                  scrollable: true,
                  autoFocus: false,
                  expands: false,
                  padding: EdgeInsets.zero,
                ).copyWith(
                  readOnly: false,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(widget.note != null ? 'Update Note' : 'Create Note'),
            ),
          ],
        ),
      ),
    );
  }
}
