import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/presentation/providers/diary_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiaryItem extends StatelessWidget {
  final DiaryEntry entry;
  // final void Function() onLongPress;
  const DiaryItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final pro = context.watch<DiaryProvider>();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        color: pro.selectedLocalIds.contains(entry.localId) ? Colors.red : null,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onLongPress: () {
            pro.enterSelection(entry.localId);
          },
          onTap: () {
            if (pro.isSelectionMode) {
              pro.toggleSelection(entry.localId);
            } else {
              Navigator.pushNamed(context, '/write', arguments: entry);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(entry.createdAt),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
