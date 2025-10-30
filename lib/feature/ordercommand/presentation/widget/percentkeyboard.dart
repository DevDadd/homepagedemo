import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Percentkeyboard extends StatefulWidget {
  final Function(String) onTextInput;
  final Function onBackspace;
  final Function(int)? onPercentSelected;
  final String? initialValue;
  final String?
  externalValue; // Giá trị cập nhật từ ngoài sau khi tính phần trăm

  const Percentkeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
    this.onPercentSelected,
    this.initialValue,
    this.externalValue,
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
    if (widget.initialValue != null) {
      currentText = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(covariant Percentkeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật khi externalValue đổi (ví dụ sau khi tính toán ngoài)
    final ext = widget.externalValue;
    if (ext != null && ext.isNotEmpty) {
      final normalized = ext.replaceAll(',', '');
      if (normalized != currentText) {
        setState(() {
          currentText = normalized;
        });
      }
    }
  }

  void _textInputHandler(String text) {
    if (text == '.' && currentText.contains('.')) return;

    setState(() {
      currentText += text;
    });
    widget.onTextInput.call(currentText);
  }

  void _applyPercent(int percent) {
    // Lấy giá trị hiện tại (nếu có)
    final base = double.tryParse(currentText.replaceAll(',', '')) ?? 0;

    // Tính giá trị sau phần trăm (để hiển thị ngay)
    final result = base * percent / 100;

    // Cập nhật UI trước
    setState(() {
      selectedMode = "$percent%";
      currentText = result.toStringAsFixed(2);
    });

    // Gửi giá trị mới ra ngoài
    widget.onTextInput.call(currentText);

    // Gọi callback tính toán bên ngoài
    widget.onPercentSelected?.call(percent);
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
                _buildPercentButton("25%"),
                _buildPercentButton("50%"),
                _buildPercentButton("75%"),
                _buildPercentButton("100%"),
                const SizedBox(width: 12),
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
            _buildRow(['1', '2', '3']),
            _buildRow(['4', '5', '6']),
            _buildRow(['7', '8', '9']),
            _buildRow(['.', '0', '⌫']),
          ],
        ),
      ),
    );
  }

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
            final percent = int.tryParse(label.replaceAll('%', ''));
            if (percent != null) {
              _applyPercent(percent);
            }
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
              ? null
              : () {
                  if (isBackspace) {
                    if (currentText.isNotEmpty) {
                      setState(() {
                        currentText = currentText.substring(
                          0,
                          currentText.length - 1,
                        );
                      });
                      widget.onBackspace.call();
                      widget.onTextInput.call(currentText);
                    }
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
