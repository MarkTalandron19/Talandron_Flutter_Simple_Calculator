import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  TextEditingController number1Controller = TextEditingController();
  TextEditingController number2Controller = TextEditingController();
  TextEditingController answerController = TextEditingController();
  String input1 = "Empty";
  String input2 = "Empty";
  double number1 = 0;
  double number2 = 0;
  String? selectedOperator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Calculator"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                width: 200,
                child: TextField(
                  controller: number1Controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll(',', '.'),
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'First Number',
                  ),
                )),
            SizedBox(
              width: 200,
              child: DropdownButton<String>(
                hint: const Center(
                  child: Text("Select Operator",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                isExpanded: true,
                value: selectedOperator,
                onChanged: (value) {
                  setState(() {
                    selectedOperator = value;
                  });
                },
                items: <String>['+', '-', '*', '/'].map((String val) {
                  return DropdownMenuItem<String>(
                      value: val,
                      child: Center(
                          child: Text(val,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ))));
                }).toList(),
              ),
            ),
            SizedBox(
                width: 200,
                child: TextField(
                  controller: number2Controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll(',', '.'),
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Second Number',
                  ),
                )),
            SizedBox(
              width: 200,
              child: TextField(
                controller: answerController,
                enabled: false,
                decoration: const InputDecoration(labelText: "Answer"),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (number1Controller.text.isEmpty ||
                      number2Controller.text.isEmpty) {
                    setState(() {
                      displayEmptyError(context);
                    });
                  } else if (selectedOperator == null) {
                    setState(() {
                      displayNullOperator(context);
                    });
                  } else {
                    setState(() {
                      input1 = number1Controller.text;
                      input2 = number2Controller.text;
                      number1 = double.parse(input1);
                      number2 = double.parse(input2);
                      answerController.text = doOperation(
                              number1, number2, selectedOperator, context)
                          .toString();
                    });
                  }
                },
                child: const Text("Calculate"))
          ],
        ),
      ),
    );
  }
}

double? doOperation(
    double num1, double num2, String? operator, BuildContext context) {
  double answer = 0;
  switch (operator) {
    case '+':
      answer = num1 + num2;
      break;
    case '-':
      answer = num1 - num2;
      break;
    case '*':
      answer = num1 * num2;
      break;
    case '/':
      {
        if (num2 == 0) {
          displayDivideByZeroError(context);
        } else {
          answer = num1 / num2;
        }
      }
      break;
    default:
      return null;
  }

  return answer;
}

Future<void> displayEmptyError(BuildContext context) async {
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.red,
            ),
          ),
          content: const Text("A textfield is empty.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      }));
}

Future<void> displayNullOperator(BuildContext context) async {
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.red,
            ),
          ),
          content: const Text("Please select an operator.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      }));
}

Future<void> displayDivideByZeroError(BuildContext context) async {
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.red,
            ),
          ),
          content: const Text("You can't divide by zero.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      }));
}
