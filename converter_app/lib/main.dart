import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.amberAccent,
          secondary: const Color(0xFF222B45),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16, // Reduced text size
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontSize: 14, 
            color: Colors.white60,
          ),
          headlineSmall: TextStyle(
            fontSize: 22, // Reduced headline size
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amberAccent,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF222B45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amberAccent),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TemperatureConverterScreenState createState() {
    return _TemperatureConverterScreenState();
  }
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final TextEditingController _tempController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFahrenheitToCelsius = true;
  String _result = '';
  final List<String> _history = [];

  double _convertFtoC(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  double _convertCtoF(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  void _convert() {
    double inputTemp = double.tryParse(_tempController.text) ?? 0.0;
    double convertedTemp;

    if (_isFahrenheitToCelsius) {
      convertedTemp = _convertFtoC(inputTemp);
      _result = "${inputTemp.toStringAsFixed(1)}°F => ${convertedTemp.toStringAsFixed(1)}°C";
    } else {
      convertedTemp = _convertCtoF(inputTemp);
      _result = "${inputTemp.toStringAsFixed(1)}°C => ${convertedTemp.toStringAsFixed(1)}°F";
    }

    setState(() {
      _history.insert(0, _result);
    });
  }

  @override
  void dispose() {
    _tempController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Converter", 
            style: TextStyle(color: Colors.white), // Set text color to white
            ),

          backgroundColor: const Color.fromARGB(255, 18, 18, 27),
        ),
        body: SingleChildScrollView( // Allows scrolling in case of overflow
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text(
                          "Fahrenheit to Celsius",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                        value: true,
                        groupValue: _isFahrenheitToCelsius,
                        onChanged: (value) {
                          setState(() {
                            _isFahrenheitToCelsius = value!;
                          });
                        },
                        activeColor: Colors.amberAccent,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text(
                          "Celsius to Fahrenheit",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                        value: false,
                        groupValue: _isFahrenheitToCelsius,
                        onChanged: (value) {
                          setState(() {
                            _isFahrenheitToCelsius = value!;
                          });
                        },
                        activeColor: Colors.amberAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60, // Increase the height of the input box
                  child: TextField(
                    controller: _tempController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      labelText: "Enter temperature",
                      labelStyle: TextStyle(fontSize: 16, color: Colors.white), // Adjusted label font size
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 18, color: Colors.white), // Adjusted input text size
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusNode);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _convert();
                    },
                    child: const Text("Convert", style: TextStyle(color: Colors.black)), // Adjusted text color to black for contrast
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Converted value: $_result",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1, color: Colors.amberAccent),
                Text(
                  "History",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200, // Adjust the height to prevent overflow
                  child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xFF222B45),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            _history[index],
                            style: const TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
