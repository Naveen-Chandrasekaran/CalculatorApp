import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentValue = '';
  List<double> valuesList = [];
  List<String> operatorsList = [];

  void calculateResult() {
    if (currentValue.isNotEmpty) {
      var temp = '';
      for (int j = 0; j < currentValue.length; j++) {
        if ('+-*/%'.contains(currentValue[j])) {
          valuesList.add(double.parse(temp));
          operatorsList.add(currentValue[j]);
          temp = '';
        } else {
          temp += currentValue[j];
        }
      }
      if (temp.isNotEmpty) {
        valuesList.add(double.parse(temp));
      }
    }

    if (valuesList.isNotEmpty && operatorsList.isNotEmpty) {
      double intermediateResult = valuesList[0];

      for (int i = 1; i < valuesList.length; i++) {
        double n1 = valuesList[i];
        String currentOperator = operatorsList[i - 1];

        switch (currentOperator) {
          case '+':
            intermediateResult += n1;
            break;
          case '-':
            intermediateResult -= n1;
            break;
          case '*':
            intermediateResult *= n1;
            break;
          case '/':
            if(n1==0){
              Fluttertoast.showToast(
                  msg: "Can't Divide By Zero",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0xFFfb7845),
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            intermediateResult = n1 != 0 ? intermediateResult / n1 : 0;
            break;
          case '%':
            intermediateResult %= n1;
            break;
        }
      }

      valuesList.clear();
      operatorsList.clear();
      currentValue = intermediateResult.toString();
    }
  }

  void updateInputValue(String value) {
    if (value == '=') {
      calculateResult();
    } else if (value == 'C') {
      currentValue = '';
      valuesList.clear();
      operatorsList.clear();
    } else if (value == 'DEL') {
      if (currentValue.isNotEmpty) {
        currentValue = currentValue.substring(0, currentValue.length - 1);
      } else if (valuesList.isNotEmpty) {
        valuesList.removeLast();
      } else if (operatorsList.isNotEmpty) {
        operatorsList.removeLast();
      }
    } else {
      currentValue += value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 20,
        centerTitle: true,
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: const Color(0xFFfb7845),
        title: const Text(
          "Calculator",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFF141f29),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              Center(
                child: Card(
                  color: const Color(0xFF212832),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SizedBox(
                    width: 350,
                    height: 170,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          currentValue,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              Center(
                child: Card(
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: const Color(0xFF010001),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: 350,
                      child: Column(
                        children: [
                          for (final row in [
                            ['C', '%', '/', 'DEL'],
                            ['7', '8', '9', '*'],
                            ['4', '5', '6', '-'],
                            ['1', '2', '3', '+'],
                            ['0', '.', '=']
                          ])
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (final label in row)
                                    '+-*/%=DEL'.contains(label)
                                        ? buildOperatorButton(label)
                                        : buildButton(label),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String label) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: label == "0" ? 145 : 70,
        height: 70,
        child: TextButton(
          onPressed: () {
            setState(() {
              updateInputValue(label);
            });
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: const Color(0xFF212832),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: label == "C" ? Colors.red : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOperatorButton(String label) {
    List<String> operators = ["add", "delete", "divide", "equal", "modulus", "multiple", "sub"];
    List<String> symbols = ['+', 'DEL', '/', '=', '%', '*', '-'];
    var name = operators[symbols.indexOf(label)];
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 70,
        height: 70,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              updateInputValue(label);
            });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: ("=DEL").contains(label) ? const Color(0xFFfb7845) : const Color(0xFF212832),
          ),
          child: Image.asset(
            "images/$name.png",
            color: Colors.white,
            width: 27,
            height: 27,
          ),
        ),
      ),
    );
  }
}
