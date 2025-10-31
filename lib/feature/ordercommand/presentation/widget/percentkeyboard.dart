import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PercentKeyboard extends StatefulWidget {
  final Function(String) onTextInput;
  final Function onBackspace;
  final Function(int)? onPercentSelected;
  final String? initialValue;
  final int? priceMaxCanBuy;

  const PercentKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
    this.onPercentSelected,
    this.initialValue,
    this.priceMaxCanBuy,
  }) : super(key: key);

  @override
  State<PercentKeyboard> createState() => _PercentKeyboardState();
}

class _PercentKeyboardState extends State<PercentKeyboard> {
  late TextEditingController controller;
  String? selectedMode;
  bool justCalculated = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void didUpdateWidget(covariant PercentKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!justCalculated &&
        widget.initialValue != null &&
        widget.initialValue != oldWidget.initialValue) {
      controller.value = TextEditingValue(
        text: widget.initialValue!,
        selection: TextSelection.collapsed(offset: widget.initialValue!.length),
      );
    }
  }

  void _textInputHandler(String text) {
    if (text == '.') return; // disallow dot entirely
    final currentRaw = controller.text.replaceAll(',', '');

    final newRaw = currentRaw + text;

    String displayText;
    if (newRaw.contains('.')) {
      displayText = newRaw;
    } else {
      final parsed = int.tryParse(newRaw) ?? 0;
      displayText = NumberFormat('#,##0', 'en_US').format(parsed);
    }

    setState(() {
      if (justCalculated) justCalculated = false;
      selectedMode = null;
      controller.value = TextEditingValue(
        text: displayText,
        selection: TextSelection.collapsed(offset: displayText.length),
      );
    });

    widget.onTextInput(newRaw);
  }

  // _applyPercent removed; percent buttons now input digits via _textInputHandler.

  void _onBackspace() {
    if (controller.text.isNotEmpty) {
      final newText = controller.text.substring(0, controller.text.length - 1);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    widget.onBackspace();
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
    final isActive = selectedMode == label;
    final bgColor = isActive
        ? const Color(0xFF1AAF74).withOpacity(0.1)
        : const Color(0xFF33383F);
    final textColor = isActive ? const Color(0xFF1AAF74) : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 14),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.2),
          onTap: () {
            final percent = int.tryParse(label.replaceAll('%', ''));
            if (percent != null) {
              final maxCanBuy = widget.priceMaxCanBuy ?? 0;
              final computed = ((maxCanBuy * percent) / 100).floor();
              final formatted = NumberFormat('#,##0', 'en_US').format(computed);

              setState(() {
                selectedMode = label;
                justCalculated = true;
                controller.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              });

              widget.onTextInput(computed.toString());
              widget.onPercentSelected?.call(percent);
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
        children: labels
            .map((label) => _buildKey(label, isBackspace: label == '⌫'))
            .toList(),
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
          splashColor: label == '.'
              ? Colors.transparent
              : Colors.white.withOpacity(0.25),
          highlightColor: label == '.'
              ? Colors.transparent
              : Colors.white.withOpacity(0.1),
          onTap: label == '.'
              ? null
              : () {
                  if (isBackspace) {
                    _onBackspace();
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
                  color: label == '.'
                      ? const Color(0xFF33383F)
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
