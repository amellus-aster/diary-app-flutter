import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/presentation/providers/diary_provider.dart';
import 'package:deardiaryv2/features/diary/presentation/screens/write.dart';
import 'package:deardiaryv2/features/diary/presentation/widgets/calendar.dart';
import 'package:deardiaryv2/features/diary/presentation/widgets/diary_item.dart';
import 'package:deardiaryv2/features/diary/presentation/widgets/pulsing_fab.dart';
import 'package:deardiaryv2/features/diary/presentation/widgets/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SortingType { newestFirst, oldestFirst }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScrolled = false;
  late TextEditingController _searchController;
  SortingType? sortingSelected = SortingType.newestFirst;
  @override
  void initState() {
    Future.microtask(() {
      context.read<DiaryProvider>().fetchDiaries();
      context.read<DiaryProvider>().sync();
    });
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void onCalendar(DiaryEntry? entry) {
    if (entry != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WriteScreen(entry: entry)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scheme = Theme.of(context).colorScheme;
    final diaryPro = context.watch<DiaryProvider>();
    final entries = diaryPro.isSearching
        ? diaryPro.searchResults
        : diaryPro.diaries;
    if (!diaryPro.isSearching) {
      _searchController.clear();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: diaryPro.isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  diaryPro.searchDebounce(value);
                },
              )
            : null,
        backgroundColor: !isScrolled ? Colors.transparent : scheme.surface,
        actions: [
          Row(
            children: [
              diaryPro.isSearching
                  ? IconButton(
                      onPressed: () {
                        diaryPro.exitSearching();
                      },
                      icon: Icon(Icons.close),
                    )
                  : IconButton(
                      onPressed: () {
                        diaryPro.enterSearching();
                      },
                      icon: Icon(Icons.search),
                    ),
              diaryPro.isSelectionMode
                  ? IconButton(
                      onPressed: () {
                        diaryPro.delete();
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    )
                  : PopupMenuButton<int>(
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (value) {
                        if (value == 1) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return AlertDialog(
                                    title: const Text("Sắp xếp theo"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RadioListTile<SortingType>(
                                          value: SortingType.newestFirst,
                                          groupValue: sortingSelected,
                                          onChanged: (value) {
                                            setStateDialog(() {
                                              sortingSelected = value!;
                                            });
                                          },
                                          title: const Text(
                                            "Mới nhất đầu tiên",
                                          ),
                                        ),
                                        RadioListTile<SortingType>(
                                          value: SortingType.oldestFirst,
                                          groupValue: sortingSelected,
                                          onChanged: (value) {
                                            setStateDialog(() {
                                              sortingSelected = value!;
                                            });
                                          },
                                          title: const Text("Cũ nhất đầu tiên"),
                                        ),
                                        SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Hủy"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  diaryPro.sortDiaries(
                                                    sortingSelected,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Lưu",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          child: Text("Sắp xếp theo"),
                        ),
                      ],
                    ),
            ],
          ),
        ],
        elevation: 0,
      ),
      drawer: SizedBox(
        width: size.width * 0.55,
        child: Drawer(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: SideMenu(),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (diaryPro.isSelectionMode) {
            diaryPro.exitSelection();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels > 0 && !isScrolled) {
                          setState(() => isScrolled = true);
                        } else if (notification.metrics.pixels <= 0 &&
                            isScrolled) {
                          setState(() => isScrolled = false);
                        }
                        return false;
                      },
                      child: Consumer<DiaryProvider>(
                        builder: (context, diaryPro, _) {
                          if (diaryPro.status == DiaryStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (diaryPro.diaries.isEmpty &&
                              diaryPro.status == DiaryStatus.success) {
                            return const Center(child: Text("Chưa viết nhật kí"));
                          }
                          if (diaryPro.status == DiaryStatus.error) {
                            return const Center(child: Text("error"));
                          }
                          if (diaryPro.status == DiaryStatus.success) {
                            return CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        height:
                                            size.height * 0.4 +
                                            MediaQuery.of(context).padding.top,
                                        width: double.infinity,
                                        child: Image.asset(
                                          './../../../../assets/images/bg1.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -40,
                                        left: 16,
                                        right: 16,
                                        child: DiaryItem(
                                          key: ValueKey(entries[0].localId),
                                          entry: entries[0],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 32),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 16,
                                    right: 16,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        return DiaryItem(
                                          key: ValueKey(
                                            entries[index + 1].localId,
                                          ),
                                          entry: entries[index + 1],
                                        );
                                      },
                                      childCount: entries.length > 1
                                          ? entries.length - 1
                                          : 0,
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 100),
                                ),
                              ],
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 20,
              left: MediaQuery.sizeOf(context).width / 5,
              child: FloatingActionButton.small(
                elevation: 0,
                heroTag: "calender",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: DiaryCalendar(
                          diaries: diaryPro.diaries,
                          onDaySelected: onCalendar,
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.calendar_month),
              ),
            ),
            Positioned(
              bottom: 20,
              right: MediaQuery.sizeOf(context).width / 5,
              child: FloatingActionButton.small(
                elevation: 0,
                heroTag: "account",
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: const Icon(Icons.person),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PulsingFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
