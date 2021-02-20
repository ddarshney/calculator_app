import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';
class HomePage extends StatefulWidget{
  @override
  State createState() =>  HomePageState();
}

class HomePageState extends State<HomePage>{
  String equation = "0", result = "0"; // Expression and FinalResult
  Map<String, String> operatorsMap = {"÷": "/", "×": "*", "−": "-", "+": "+"};
  List buttonNames = [
    "7",
    "8",
    "9",
    "÷",
    "4",
    "5",
    "6",
    "×",
    "1",
    "2",
    "3",
    "−",
    "0",
    ".",
    "⌫",
    "+"
  ];
  void evaluateEquation() {
    try {
      // Fix equation
      Expression exp = (Parser()).parse(operatorsMap.entries.fold(
          equation, (prev, elem) => prev.replaceAll(elem.key, elem.value)));

      double res = double.parse(
          exp.evaluate(EvaluationType.REAL, ContextModel()).toString());

      // Output correction for decimal results
      result = double.parse(res.toString()) == int.parse(res.toStringAsFixed(0))
          ? res.toStringAsFixed(0)
          : res.toStringAsFixed(4);
    } catch (e) {
      result = "Error";
    }
  }

  Widget _buttonPressed(String text, {bool isClear = false}) {
    setState(() {
      if (isClear) {
        // Reset calculator
        equation = result = "0";
      } else if (text == "⌫") {
        // Backspace
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") equation = result = "0"; // If all empty
      } else {
        // Default
        if (equation == "0" && text != ".") equation = "";
        equation += text;
      }

      // Only evaluate if correct expression
      if (!operatorsMap.containsKey(equation.substring(equation.length - 1)))
        evaluateEquation();
    });
  }

  // Grid of buttons

  // Grid of buttons
  Widget _buildButtons() {
    return Material(
      color: Colors.black,
      child: GridView.count(
          crossAxisCount: 4, // 4x4 grid
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(5),
          children: buttonNames.map<Widget>((e) {
            switch (e) {
              case "+": // Addition Button
                return _buildFancyButton(e, isBottom: true);
              case "×": // Multiplication Button
                return _buildFancyButton(e);
              case "−": // Subtraction Button
                return _buildFancyButton(e);
              case "÷": // Division Button
                return _buildFancyButton(e, isTop: true);
              default:
                return _button(e, 0);
            }
          }).toList()),
    );
  }

  // Normal button
  Widget _button(text, double paddingBot) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(70)), // Circular
        color: Colors.grey[800],
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return InkWell(
                  // Ripple Effect

                  borderRadius: BorderRadius.all(Radius.circular(70)),
                  onTap: () {
                    _buttonPressed(text);
                  },
                  child: Container(
                    // For ripple area
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: GoogleFonts.montserrat(
                        fontSize: 50,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  // Operator Button
  Widget _buildFancyButton(text, {bool isTop = false, bool isBottom = false}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(70)),
        color: Colors.green,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(70)),
          onTap: () {
            _buttonPressed(text);
          },
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 50,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
            // Expression Area - Top - Smallest Size
            flex: 1,
            child: Container(

              decoration: BoxDecoration(
                // Bottom Divider
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // Expression

                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10, 20, 5, 0),
                    child: Row(
                      children: <Widget>[
                        Text(equation,
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // Clear Btn
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            borderRadius: BorderRadius.circular(70.0),
                            onTap: () => {_buttonPressed("AC", isClear: true)},
                            child: Container(
                              alignment: Alignment.center,
                              height: 15,
                              width: 15,
                              child: Text(
                                "AC",
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            // Result Area - Mid - Medium Size Ratio
            flex: 3,
            child: Container(
              color: Colors.black,
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: Text(
                  result,
                  style: GoogleFonts.montserrat(
                    fontSize: 50,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            // Controls Area - Bottom - Max Size Ration
            flex: 7,
            child: _buildButtons(),
          )
        ],
      ),
    );
  }
}