import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Percentkeyboard extends StatefulWidget {
  final Function(String) onTextInput;
  final Function onBackspace;
  final Function(int)? onPercentSelected; // ✅ callback khi chọn phần trăm
  final String? initialValue; // Giá trị hiện tại để check đã có dấu chấm chưa

  const Percentkeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
    this.onPercentSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  State<Percentkeyboard> createState() => _PercentkeyboardState();
}

class _PercentkeyboardState extends State<Percentkeyboard> {
  String? selectedMode;
  String currentText = "";

  @override
  void initState() {
    super.initState();
    // Khởi tạo currentText với giá trị ban đầu (nếu có)
    if (widget.initialValue != null) {
      currentText = widget.initialValue!;
    }
  }

  void _textInputHandler(String text) {
    // Nếu là dấu chấm, chỉ cho phép nhập nếu chưa có dấu chấm
    if (text == '.' && currentText.contains('.')) {
      return; // Đã có dấu chấm rồi, không cho nhập thêm
    }

    setState(() {
      currentText += text;
    });

    // Chỉ truyền currentText, logic bên ngoài sẽ set trực tiếp
    widget.onTextInput.call(currentText);
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

                // 🔹 Các nút phần trăm
                _buildPercentButton("25%"),
                _buildPercentButton("50%"),
                _buildPercentButton("75%"),
                _buildPercentButton("100%"),

                const SizedBox(width: 12),

                // 🔹 Nút "Xong"
                InkWell(
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

  // 🟩 Nút phần trăm (25%, 50%, 75%, 100%)
  Widget _buildPercentButton(String label) {
    final bool isActive = selectedMode == label;
    final Color activeColor = const Color(0xFF1AAF74);

    final Color bgColor = isActive
        ? activeColor.withOpacity(0.1)
        : const Color(0xFF33383F);
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
          onTap: () {
            setState(() {
              selectedMode = label;
            });

            // ✅ Gọi callback phần trăm nếu có
            final percent = int.tryParse(label.replaceAll('%', ''));
            if (percent != null) {
              widget.onPercentSelected?.call(percent);
            }

            // Gửi text ra ngoài nếu cần xử lý thêm
            _textInputHandler(label);
          },
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
    // Tắt nút dấu chấm cho volume keyboard
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
              ? () {}
              : () {
                  if (isBackspace) {
                    // Xử lý xóa ký tự
                    if (currentText.isNotEmpty) {
                      setState(() {
                        currentText = currentText.substring(
                          0,
                          currentText.length - 1,
                        );
                      });
                      widget.onBackspace.call();
                      // Cập nhật giá trị ra ngoài sau khi xóa
                      widget.onTextInput.call(currentText);
                    }
                  } else if (label.isNotEmpty) {
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
