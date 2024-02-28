import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/bookmark_state.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/utils/colors.dart';
import 'package:provider/provider.dart';

class BookmarkFilter extends StatelessWidget {
  const BookmarkFilter({super.key});

  Widget buildDisplay(BuildContext context, BookmarkState state) {
    switch (state) {
      case BookmarkState.all:
        return const Center(child: Text("All"));
      case BookmarkState.yes:
        return Icon(
          Icons.bookmark_added,
          color: Theme.of(context).colorScheme.made,
        );
      case BookmarkState.no:
        return Icon(
          Icons.bookmark_added_outlined,
          color: Theme.of(context).colorScheme.made,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSetting>(builder: (context, userSetting, child) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          const Text("Show Bookmarked: "),
          ActionChip(
            labelPadding: EdgeInsets.zero,
            shape: const CircleBorder(),
            onPressed: () => userSetting.toggleBookmarkState(),
            label: SizedBox(
              height: 30,
              width: 30,
              child: buildDisplay(context, userSetting.bookmarkState),
            ),
          ),
        ],
      );
    });
  }
}
