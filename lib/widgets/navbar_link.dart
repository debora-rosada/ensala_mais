import 'package:flutter/material.dart';
import '../utils/project_colors.dart';

class NavbarLink extends StatefulWidget {
  final String text;
  final Widget? modal;
  final VoidCallback? onPressed;
  
  const NavbarLink({
    super.key,
    required this.text,
    required this.modal,
    this.onPressed,
  });
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
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
        ),
        onPressed: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          } else if (widget.modal != null) {
            showDialog(
              useSafeArea: true,
              context: context,
              builder: (context) {
                return widget.modal!;
              },
            );
          }
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
