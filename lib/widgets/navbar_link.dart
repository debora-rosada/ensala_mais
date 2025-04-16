import 'package:ensala_mais/widgets/modal.dart';
import 'package:flutter/material.dart';

import '../utils/project_colors.dart';

class NavbarLink extends StatefulWidget {
  final String text;
  const NavbarLink({super.key, required this.text});

  @override
  State<NavbarLink> createState() => _NavbarLinkState();
}

class _NavbarLinkState extends State<NavbarLink> {
  Color _textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (event) {
        setState(() {
          _textColor = ProjectColors().navbarTextColor;
        });
      },
      onHover: (event) {
        setState(() {
          _textColor = ProjectColors().navbarTextHoverColor;
        });
      },
      child: TextButton(
        style: ButtonStyle(
          // fixedSize: WidgetStatePropertyAll(
          //   Size(125, 25),
          // ),
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
        ),
        onPressed: () {
          print('entrei no modulo ${widget.text}');
          showDialog(
              useSafeArea: true,
              context: context,
              builder: (context) {
                return Modal();
              });
        },
        child: Text(
          widget.text,
          style: TextStyle(
            color: _textColor,
          ),
        ),
      ),
    );
  }
}