import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dialogs.dart';
import '../styles/tokens.dart';
import '../core/constants.dart';

class JoinQuizScreen extends StatefulWidget {
  const JoinQuizScreen({super.key});

  @override
  State<JoinQuizScreen> createState() => _JoinQuizScreenState();
}

enum JoinMode { pin, qr }

class _JoinQuizScreenState extends State<JoinQuizScreen> {
  final _codeCtrl = TextEditingController();
  JoinMode _mode = JoinMode.pin;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final raw = _codeCtrl.text.replaceAll(' ', '');
    if (raw.length != kQuizCodeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan PIN $kQuizCodeLength digit')),
      );
      return;
    }
    final name = await showNamePrompt(context);
    if (name == null || name.trim().isEmpty) return;
    if (!mounted) return;
    context.push('/quiz/$raw/play', extra: name.trim());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      titleText: 'Join Quiz',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Segmented controls (PIN / QR)
            SegmentedButton<JoinMode>(
              segments: const [
                ButtonSegment(value: JoinMode.pin, label: Text('Enter PIN')),
                ButtonSegment(value: JoinMode.qr, label: Text('Scan QR Code')),
              ],
              selected: <JoinMode>{_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
              showSelectedIcon: false,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: AppRadius.button)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (_mode == JoinMode.pin) ...[
              // Big code input, centered
              Container(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: AppRadius.button,
                ),
                child: Center(
                  child: SizedBox(
                    width: 380,
                    child: TextField(
                      controller: _codeCtrl,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSecondaryContainer,
                          ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _SpacedNDigitsFormatter(kQuizCodeLength),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: '000 000',
                      ),
                      maxLength: kQuizCodeLength + 1, // includes the space for 3-3 formatting
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _join,
                  child: const Text('JOIN NOW'),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: AppRadius.button,
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_scanner, size: 56),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Scan QR will be available soon', style: TextStyle(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpacedNDigitsFormatter extends TextInputFormatter {
  _SpacedNDigitsFormatter(this.length);
  final int length;
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > length ? digits.substring(0, length) : digits;
    final buf = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (length == 6 && i == 3) buf.write(' '); // default 3-3 spacing
      buf.write(limited[i]);
    }
    final text = buf.toString();
    // Position caret at end
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
