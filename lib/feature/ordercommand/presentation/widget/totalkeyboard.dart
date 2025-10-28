import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalKeyboard extends StatefulWidget {
  final Function(String) onTextInput;
  final Function onBackspace;
  final Function(int)? onPercentSelected; // ✅ callback khi chọn phần trăm

  const TotalKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
    this.onPercentSelected,
  }) : super(key: key);

  @override
  State<TotalKeyboard> createState() => _TotalKeyboardState();
}

class _TotalKeyboardState extends State<TotalKeyboard> {
  String? selectedMode;

  void _textInputHandler(String text) => widget.onTextInput.call(text);

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
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.of(context).pop(),
                    splashColor: Colors.white.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                ),
              ],
            ),

            // 🔹 Các hàng số
            _buildRow(['1', '2', '3']),
            _buildRow(['4', '5', '6']),
            _buildRow(['7', '8', '9']),
            _buildRow(['.', '0', '⌫']),
          ],
        ),
      ),
    );
  }

  // 🟩 Hàng số
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

  // 🟩 Nút số / backspace
  Widget _buildKey(String label, {bool isBackspace = false}) {
    // Tắt nút dấu chấm cho total keyboard
    final isDisabled = label == '.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        color: const Color(0xFF1A1D1F),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: isDisabled
              ? Colors.transparent
              : Colors.white.withOpacity(0.25),
          highlightColor: isDisabled
              ? Colors.transparent
              : Colors.white.withOpacity(0.1),
          onTap: isDisabled
              ? () {} // Empty function để không làm gì
              : () {
                  if (isBackspace) {
                    widget.onBackspace.call();
                  } else {
                    _textInputHandler(label);
                  }
                },
          child: SizedBox(
            width: 111.67,
            height: 40,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isDisabled
                      ? const Color(0xFF3A3E42)
                      : const Color(0xFF6F767E),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
