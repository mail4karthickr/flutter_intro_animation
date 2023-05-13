import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final String hint;
  final Icon leadingIcon;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  const CustomTextField({super.key, 
    required this.text,
    required this.hint,
    required this.leadingIcon,
    this.isPassword = false,
    required this.onChanged,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: widget.leadingIcon,
              ),
              Expanded(
                child: widget.isPassword
                    ? TextField(
                        controller: _controller,
                        onChanged: widget.onChanged,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : TextField(
                        controller: _controller,
                        onChanged: widget.onChanged,
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
