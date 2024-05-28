import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:school_app/src/pages/home/find_notes/findnotes.dart';
import 'package:school_app/src/pages/home/main/homepage2.dart';
import 'package:school_app/src/pages/home/mysubjects/mysubjects.dart';
import 'package:school_app/src/pages/home/savednotes/savednotes.dart';
import 'package:school_app/src/utils/firebase.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageWithDrawer extends StatefulWidget {
  const PageWithDrawer({super.key});

  @override
  State<PageWithDrawer> createState() => _PageWithDrawerState();
}

class _PageWithDrawerState extends State<PageWithDrawer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  var _bottomNavIndex = 0;

  PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                context.go("/home/profile");
              },
              icon: Hero(
                tag: Auth.currentUser!.uid,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(Auth.currentUser!.photoURL ?? ""),
                ),
              ))
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        notchAndCornersAnimation: _animationController,
        itemCount: icons.length,
        gapLocation: GapLocation.end,
        tabBuilder: (index, isActive) {
          final color = isActive ? Colors.blue : Colors.blueGrey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icons[index],
              const SizedBox(height: 4),
              Text(
                labels[index],
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                ),
              ),
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        onTap: (index) {
          if (index == 2) {
            context.push("/addnote");
          } else {
            setState(() {
              _bottomNavIndex = index;
            });
          }
        },
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _pages,
      ),
    );
  }

  List icons = [
    const Icon(Icons.home),
    const Icon(Icons.search),
    const Icon(Icons.add),
    const Icon(Icons.star),
    const Icon(Icons.bookmark),
  ];

  List<String> labels = [
    'Home',
    'Search',
    'Add',
    'Saved',
    'Priority',
  ];


  Widget getPage() {
    return _pages[_bottomNavIndex];
  }

  final List<Widget> _pages = [
    const MainHomePage(),
    const SearchPage(),
    Container(),
    const SavedNotesPage(),
    const PrioritySubjects(),
  ];
}

Widget getSvgIcon(String path) {
  return SvgPicture.asset(
    path,
  );
}
