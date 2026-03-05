import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/presentation/providers/diary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WriteScreen extends StatefulWidget {
  final DiaryEntry? entry;
  const WriteScreen({super.key, this.entry});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool hasWrite = false;
  @override
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');

    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );

    _contentController.addListener(() {
      setState(() {
        hasWrite = _contentController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.entry != null;
    final scheme = Theme.of(context).colorScheme;
    final diaryPro = context.read<DiaryProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: OutlinedButton(
              onPressed: hasWrite
                  ? () {
                      if (isEdit) {
                        diaryPro.update(
                          widget.entry!.localId,
                          _titleController.text,
                          _contentController.text,
                        );
                      } else {
                        diaryPro.add(
                          _titleController.text,
                          _contentController.text,
                        );
                      }
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: TweenAnimationBuilder<Offset>(
                  tween: Tween(begin: const Offset(0, 20), end: Offset.zero),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  builder: (context, offset, child) {
                    return Transform.translate(offset: offset, child: child);
                  },
                  child: Text(
                    widget.entry == null
                        ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.now()).toString()
                        : DateFormat(
                            'dd/MM/yyyy',
                          ).format(widget.entry!.createdAt).toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Tiêu đề",
                filled: true,
                fillColor: scheme.surface,
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "Hôm nay của bạn thế nào?",
                  filled: true,
                  fillColor: scheme.surface,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
