import 'package:flutter/material.dart';

typedef NumberChanged = void Function(String number);
typedef CallRequested = Future<void> Function(String number);

class PhoneKeypad extends StatefulWidget {
  final String initialNumber;
  final NumberChanged? onChanged;
  final CallRequested? onCall;
  final String callLabel;

  const PhoneKeypad({
    super.key,
    this.initialNumber = '',
    this.onChanged,
    this.onCall,
    this.callLabel = 'Call',
  });

  @override
  State<PhoneKeypad> createState() => _PhoneKeypadState();
}

class _PhoneKeypadState extends State<PhoneKeypad> {
  String _number = '';

  @override
  void initState() {
    super.initState();
    _number = widget.initialNumber;
  }

  void _append(String d) {
    setState(() {
      _number = _number + d;
    });
    widget.onChanged?.call(_number);
  }

  void _backspace() {
    if (_number.isNotEmpty) {
      setState(() {
        _number = _number.substring(0, _number.length - 1);
      });
      widget.onChanged?.call(_number);
    }
  }

  void _clear() {
    setState(() {
      _number = '';
    });
    widget.onChanged?.call(_number);
  }

  Widget _buildKey(String label, {double size = 24}) {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: () => _append(label),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(label, style: TextStyle(fontSize: size, fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _number.isEmpty ? 'Enter number' : _number,
                  style: TextStyle(fontSize: 20, color: _number.isEmpty ? Colors.grey : Colors.black),
                ),
              ),
              IconButton(
                tooltip: 'Clear',
                icon: Icon(Icons.close, color: Colors.redAccent),
                onPressed: _clear,
                onLongPress: _clear,
              ),
            ],
          ),
        ),

        // Keypad Keys
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final r in [
              ['1','2','3'],
              ['4','5','6'],
              ['7','8','9'],
              ['*','0','#']
            ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final k in r) _buildKey(k),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Backspace + Call row
        Row(
          children: [
            // Backspace Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _backspace,
                onLongPress: _clear,
                icon: const Icon(Icons.backspace_outlined),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Call button
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.call),
                label: Text(widget.callLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _number.isEmpty
                    ? null
                    : () async {
                        if (widget.onCall != null) {
                          await widget.onCall!.call(_number);
                        }
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
