import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Lamina(),
      theme: ThemeData(
          primaryColor: Colors.orangeAccent, brightness: Brightness.dark),
    );
  }
}

class Lamina extends StatefulWidget {
  Lamina({Key? key}) : super(key: key);

  @override
  _LaminaState createState() => _LaminaState();
}

class _LaminaState extends State<Lamina> {
  String? _startMeasure;
  String? _convertedMeasure;
  final cF = TextEditingController();
  final cT = TextEditingController();
  String _resultMessage = '';
  late double _numberFrom;
  String valorConvertido = '0';
  final TextStyle inputStyle = TextStyle(
    fontSize: 60,
    color: Colors.blue[900],
  );
  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];
  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };
  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    cF.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _numberFrom = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            'Convertidor-Jhonel L',
            style: TextStyle(letterSpacing: 6),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding:
                            const EdgeInsets.only(right: 20, left: 20, top: 20),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 1,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'VALUE',
                                  style:
                                      TextStyle(fontSize: 20, letterSpacing: 6),
                                )),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.all(50),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'ingresa tu medida aqui',
                            contentPadding: EdgeInsets.all(20.0),
                          ),
                          onChanged: (text) {
                            var rv = double.tryParse(text);
                            if (rv != null) {
                              setState(() {
                                _numberFrom = rv;
                              });
                            }
                          },
                        )),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text('From'),
                      ),
                    ),
                    DropdownButton(
                      items: _measures.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: _startMeasure,
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          _startMeasure = value.toString();
                          print(_startMeasure);
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text('To'),
                      ),
                    ),
                    DropdownButton(
                      items: _measures.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _convertedMeasure = value.toString();
                        });
                      },
                      value: _convertedMeasure,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_startMeasure!.isEmpty ||
                              _convertedMeasure!.isEmpty ||
                              _numberFrom == 0) {
                            print(_numberFrom);
                            return;
                          } else {
                            print('convert');
                            convert(_numberFrom, _startMeasure!,
                                _convertedMeasure!);
                          }
                        },
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(10),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.black54)),
                        child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'convert',
                              style: TextStyle(letterSpacing: 6, fontSize: 20),
                            ))),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(valorConvertido),
                  ],
                ))));
  }

  void convert(double value, String from, String to) {
    print('hola');
    int nFrom = _measuresMap[from]!;
    int nTo = _measuresMap[to]!;
    var multiplier = _formulas[nFrom.toString()][nTo];
    double result = value * multiplier;
    if (result == 0) {
      _resultMessage = 'This conversion cannot be performed';
    } else {
      _resultMessage =
          '${_numberFrom.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';
    }
    setState(() {
      valorConvertido = _resultMessage;
    });
  }
}
