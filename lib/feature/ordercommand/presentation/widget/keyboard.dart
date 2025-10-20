import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onTextInput;
  final Function onBackspace;

  const CustomKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
  }) : super(key: key);

  void _textInputHandler(String text) => onTextInput.call(text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 298,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF272B30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 10, top: 14),
                child: SvgPicture.asset("assets/icons/leftarr.svg"),
              ),
              SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 10, top: 14),
                child: SvgPicture.asset("assets/icons/rightarr.svg"),
              ),
              SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 10, top: 14),
                child: Container(
                  width: 55,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF1AAF74).withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      "LO",
                      style: GoogleFonts.manrope(
                        color: Color(0xFF1AAF74),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 14),
                child: Container(
                  width: 55,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF33383F),
                  ),
                  child: Center(
                    child: Text(
                      "MP",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 14),
                child: Container(
                  width: 55,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF33383F),
                  ),
                  child: Center(
                    child: Text(
                      "ATO",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
      child: SizedBox(
        width: 111.67,
        height: 40,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (isBackspace) {
              onBackspace.call();
            } else {
              _textInputHandler(label);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D1F),
              borderRadius: BorderRadius.circular(8),
            ),
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
