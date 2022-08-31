import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget {
  final TabController tabController;
  const AppTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: TabBar(
        controller: tabController,
        labelPadding: const EdgeInsets.all(10.0),
        indicator: UnderlineTabIndicator(
          insets: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          borderSide: BorderSide(
              width: 5.0, color: Theme.of(context).colorScheme.onSecondary),
        ),
        tabs: const [
          Tooltip(
              message: 'In Progress',
              child: Icon(Icons.check_box_outline_blank)),
          Tooltip(message: 'Finished', child: Icon(Icons.check_box))
        ],
      ),
    );
  }
}
