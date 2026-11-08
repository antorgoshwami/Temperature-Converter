import 'package:flutter/material.dart';

import 'converter.dart';

void main() => runApp(const TemperatureConverterApp());

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0A84FF),
        scaffoldBackgroundColor: const Color(0xFFF3F6FC),
      ),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _controller = TextEditingController();

  ConversionType _type = ConversionType.fahrenheitToCelsius;
  String? _errorText;
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final input = _controller.text.trim();

    // Validation: empty
    if (input.isEmpty) {
      setState(() {
        _errorText = 'Please enter a temperature value';
        _result = '';
      });
      return;
    }

    // Validation: not a valid number
    final value = double.tryParse(input);
    if (value == null || value.isNaN || value.isInfinite) {
      setState(() {
        _errorText = 'Please enter a valid number';
        _result = '';
      });
      return;
    }

    final converted = TemperatureConverter.convert(value, _type);
    setState(() {
      _errorText = null;
      _result = '${converted.toStringAsFixed(4)} ${_type.resultUnit}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Temperature Converter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Input
                    TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Degrees',
                        hintText: 'e.g. 72',
                        errorText: _errorText,
                      ),
                      onSubmitted: (_) => _calculate(),
                    ),
                    const SizedBox(height: 20),

                    // Conversion type dropdown
                    InputDecorator(
                      decoration: const InputDecoration(labelText: 'Type'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ConversionType>(
                          value: _type,
                          isExpanded: true,
                          isDense: true,
                          items: ConversionType.values
                              .map((t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t.label),
                                  ))
                              .toList(),
                          onChanged: (t) {
                            if (t == null) return;
                            setState(() {
                              _type = t;
                              _result = '';
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Result
                    InputDecorator(
                      decoration: const InputDecoration(labelText: 'Result'),
                      child: Text(
                        _result.isEmpty ? '—' : _result,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Calculate button
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _calculate,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Calculate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
