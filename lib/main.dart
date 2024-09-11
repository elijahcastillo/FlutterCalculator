import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elijahs Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = ""; // To store the current expression
  String result = "0"; // To display the result or current value

  // Function to handle button press
  void onButtonPress(String value) {
    setState(() {
      if (value == "<-") {
        // Backspace expression
        if (expression != null && expression.length > 0) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (value == "C") {
        // Clear the input
        expression = "";
        result = "0";
      } else if (value == "=") {
        // Evaluate the expression and handle errors
        try {
          Expression exp = Expression.parse(expression);
          final evaluator = const ExpressionEvaluator();
          var evalResult = evaluator.eval(exp, {});
          result = evalResult.toString();
          expression += " = $result";
        } catch (e) {
          result = "Error";
        }
      } else {
        // Add value of the button that was pressed to the currnent expression as a big string
        expression += value;
      }
    });
  }

  Widget buildButton(String label,
      {Color? backgroundColor, Color? textColor, double? elevation}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 60.0,
          child: ElevatedButton(
            onPressed: () => onButtonPress(label),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  backgroundColor ?? const Color.fromARGB(255, 211, 211, 211),
              elevation: elevation ?? 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 24,
                color: textColor ??
                    const Color.fromARGB(255, 17, 17, 17), // Default text color
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOperationButton(String label) {
    return buildButton(label,
        textColor: Colors.green[400], backgroundColor: Colors.grey[200]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Elijah\'s Calculator',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto',
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Display showing the ongoing calculation
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(
                expression,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
          ),

          // Display showing the result
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(
                result,
                style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.right,
              ),
            ),
          ),

          // Buttons in grid-like layout
          Column(
            children: [
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildOperationButton("/"),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildOperationButton("*"),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildOperationButton("-"),
                ],
              ),
              Row(
                children: [
                  buildButton("0"),
                  buildButton("."),
                  buildOperationButton("%"),
                  buildOperationButton("+"),
                ],
              ),
              Row(
                children: [
                  buildButton("C", backgroundColor: Colors.red),
                  buildButton("<-",
                      backgroundColor: Colors.black, textColor: Colors.white),
                  buildButton("=",
                      backgroundColor: Colors.green, textColor: Colors.white),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
