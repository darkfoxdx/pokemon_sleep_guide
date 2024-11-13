import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/sort_order.dart';
import 'package:pokemon_sleep_guide/model/sort_type.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/utils/colors.dart';
import 'package:provider/provider.dart';

class SortTool extends StatelessWidget {
  const SortTool({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSetting>(builder: (context, userSetting, child) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          const Text("Sort by: "),
          ChoiceChip(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (bool selected) => userSetting.setSortType(SortType.avail),
            showCheckmark: false,
            label: const Text("Avail"),
            selected: userSetting.sortType == SortType.avail,
          ),
          ChoiceChip(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (bool selected) => userSetting.setSortType(SortType.total),
            showCheckmark: false,
            label: const Text("Ingr Total"),
            selected: userSetting.sortType == SortType.total,
          ),
          ChoiceChip(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (bool selected) => userSetting.setSortType(SortType.variety),
            showCheckmark: false,
            label: const Text("Ingr Count"),
            selected: userSetting.sortType == SortType.variety,
          ),
          ActionChip(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            onPressed: () => userSetting.toggleSortOrder(),
            label: Icon(
              userSetting.sortOrder == SortOrder.asc ? Icons.arrow_upward : Icons.arrow_downward,
              color: Theme.of(context).colorScheme.made,
            ),
          ),
        ],
      );
    });
  }
}
