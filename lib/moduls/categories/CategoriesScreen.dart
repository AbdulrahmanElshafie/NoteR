import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_list_view/group_list_view.dart';

import '../../bloc/user/user_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tags = context.read<UserBloc>().user.tags;
    print(tags[0]?.notes);
    return GroupListView(
      sectionsCount: context.read<UserBloc>().user.tags.keys.length,
      countOfItemInSection: (int section) {
        return tags.values.toList()[section].notes.length;
      },
      itemBuilder: (BuildContext context, IndexPath index) {
        return Text(
          // context.read<UserBloc>().user.notes[tags.values.toList()[index.section].notes[index.index]]?.title
          "Item ${tags.values.toList()[index.section].notes[index.index]}",
          style: TextStyle(fontSize: 18),
        );
      },
      groupHeaderBuilder: (BuildContext context, int section) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Center(
            child: Text(
              "Header ${tags[tags.keys.toList()[section]]?.name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10),
      sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
    );
  }
}
