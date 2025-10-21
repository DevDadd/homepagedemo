import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomKeyboard extends StatefulWidget {
  final Function(String) onTextInput;
  final Function onBackspace;
  final Function(String?) onModeChanged;
  final String? selectedMode;
  final String currentText;
  final double giaTran;

  const CustomKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
    required this.onModeChanged,
    required this.selectedMode,
    required this.currentText,
    required this.giaTran,
  }) : super(key: key);

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  String? localSelectedMode;

  @override
  void initState() {
    super.initState();
    localSelectedMode = widget.selectedMode;
    print('[DEBUG] initState -> localSelectedMode = $localSelectedMode');
  }

  @override
  void didUpdateWidget(covariant CustomKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMode != oldWidget.selectedMode) {
      localSelectedMode = widget.selectedMode;
      print('[DEBUG] didUpdateWidget -> localSelectedMode = $localSelectedMode');
    }
  }

  void _textInputHandler(String text) {
    print('[DEBUG] onTextInput("$text") được gọi');
    widget.onTextInput.call(text);
  }

  void _modeTap(String mode) {
    print('\n==============================');
    print('[DEBUG] _modeTap START -> mode=$mode, localSelectedMode=$localSelectedMode');

    setState(() {
      localSelectedMode = mode;
    });

    widget.onModeChanged(mode);
    print('[DEBUG] Đã gọi onModeChanged("$mode")');

    if (mode == "LO") {
      final text = widget.giaTran.toStringAsFixed(2);
      print('[DEBUG] Mode LO được chọn → set giá trần = $text');
      _textInputHandler(text);
    } else {
      print('[DEBUG] Mode khác LO → set text = $mode');
      _textInputHandler(mode);
    }

    print('[DEBUG] _modeTap END');
    print('==============================\n');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF272B30),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 298,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 10, top: 14),
                  child: SvgPicture.asset("assets/icons/leftarr.svg"),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 10, top: 14),
                  child: SvgPicture.asset("assets/icons/rightarr.svg"),
                ),
                const SizedBox(width: 12),
                _buildModeButton("LO"),
                _buildModeButton("MP"),
                _buildModeButton("ATO"),
                _buildModeButton("ATC"),
                const SizedBox(width: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.of(context).pop(),
                  splashColor: Colors.white.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "Xong",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1AAF74),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildRow(['1', '2', '3']),
            _buildRow(['4', '5', '6']),
            _buildRow(['7', '8', '9']),
            _buildRow(['.', '0', '⌫']),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String label) {
    final bool isActive = localSelectedMode == label;
    final Color activeColor = const Color(0xFF1AAF74);

    final Color bgColor =
        isActive ? activeColor.withOpacity(0.1) : const Color(0xFF33383F);
    final Color textColor = isActive ? activeColor : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 14),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.05),
          onTap: () => _modeTap(label),
          child: SizedBox(
            width: 55,
            height: 28,
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: labels.map((label) {
          final isBackspace = label == '⌫';
          return _buildKey(label, isBackspace: isBackspace);
        }).toList(),
      ),
    );
  }

  Widget _buildKey(String label, {bool isBackspace = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        color: const Color(0xFF1A1D1F),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.white.withOpacity(0.25),
          highlightColor: Colors.white.withOpacity(0.1),
          onTap: () {
            if (isBackspace) {
              print('[DEBUG] Backspace pressed');
              widget.onBackspace();
              if (widget.currentText.isEmpty) {
                print('[DEBUG] currentText empty → reset mode');
                setState(() => localSelectedMode = null);
                widget.onModeChanged(null);
              }
            } else {
              print('[DEBUG] Key "$label" pressed');
              _textInputHandler(label);
            }
          },
          child: SizedBox(
            width: 111.67,
            height: 40,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6F767E),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
