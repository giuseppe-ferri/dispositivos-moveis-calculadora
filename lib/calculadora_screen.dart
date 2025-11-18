import 'package:flutter/material.dart';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final controller = CalculadoraController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [

                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    child: Text(
                      controller.display,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    _button(
                      label: "AC",
                      color: Colors.grey,
                      onTap: controller.clear,
                    ),
                    _button(
                      label: "+/-",
                      color: Colors.grey,
                      onTap: controller.changeSignal,
                    ),
                    _buttonIcon(
                      icon: Icons.backspace_outlined,
                      color: Colors.grey,
                      onTap: controller.deleteDigit,
                    ),
                    _button(
                      label: "/",
                      color: const Color.fromARGB(255, 81, 255, 0),
                      onTap: () => controller.setOperation("/"),
                    ),
                  ],
                ),

                Row(
                  children: [
                    for (var n in ["7", "8", "9"])
                      _button(
                        label: n,
                        onTap: () => controller.addDigit(n),
                      ),
                    _button(
                      label: "x",
                      color: const Color.fromARGB(255, 81, 255, 0),
                      onTap: () => controller.setOperation("x"),
                    ),
                  ],
                ),

                Row(
                  children: [
                    for (var n in ["4", "5", "6"])
                      _button(
                        label: n,
                        onTap: () => controller.addDigit(n),
                      ),
                    _button(
                      label: "-",
                      color: const Color.fromARGB(255, 81, 255, 0),
                      onTap: () => controller.setOperation("-"),
                    ),
                  ],
                ),

                Row(
                  children: [
                    for (var n in ["1", "2", "3"])
                      _button(
                        label: n,
                        onTap: () => controller.addDigit(n),
                      ),
                    _button(
                      label: "+",
                      color: const Color.fromARGB(255, 81, 255, 0),
                      onTap: () => controller.setOperation("+"),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        child: FloatingActionButton(
                          child:
                              const Text("0", style: TextStyle(fontSize: 20)),
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 65, 65, 65),
                          shape: const StadiumBorder(),
                          onPressed: controller.addZero,
                        ),
                      ),
                    ),
                    _button(
                      label: ".",
                      onTap: controller.addDecimal,
                    ),
                    _button(
                      label: "=",
                      color: const Color.fromARGB(255, 81, 255, 0),
                      onTap: controller.calculate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _button({
    required String label,
    required VoidCallback onTap,
    Color color = const Color.fromARGB(255, 65, 65, 65),
  }) {
    return Expanded(
      child: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: const CircleBorder(),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buttonIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color color = const Color.fromARGB(255, 65, 65, 65),
  }) {
    return Expanded(
      child: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          child: Icon(icon, size: 24),
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: const CircleBorder(),
          onPressed: onTap,
        ),
      ),
    );
  }
}

class CalculadoraController extends ChangeNotifier {
  String display = "";
  double num1 = 0;
  double num2 = 0;
  String operation = "";

  void addDigit(String digit) {
    if (display == "0") {
      display = digit;
    } else {
      display += digit;
    }
    notifyListeners();
  }

  void clear() {
    display = "";
    num1 = 0;
    num2 = 0;
    operation = "";
    notifyListeners();
  }

  void changeSignal() {
    if (display.isNotEmpty) {
      double value = double.tryParse(display) ?? 0;
      value = value * -1;

      if (value % 1 == 0) {
        display = value.toInt().toString();
      } else {
        display = value.toString();
      }

      notifyListeners();
    }
  }

  void setOperation(String op) {
    if (display.isNotEmpty) {
      num1 = double.parse(display);
      operation = op;
      display = "";
      notifyListeners();
    }
  }

  void addDecimal() {
    if (!display.contains(".")) {
      display += ".";
      notifyListeners();
    }
  }

  void addZero() {
    if (display == "" || display != "0") {
      display += "0";
      notifyListeners();
    }
  }

  void calculate() {
    if (display.isEmpty || operation.isEmpty) return;

    num2 = double.parse(display);
    double result = 0;

    switch (operation) {
      case "+":
        result = num1 + num2;
        break;
      case "-":
        result = num1 - num2;
        break;
      case "x":
        result = num1 * num2;
        break;
      case "/":
        if (num2 == 0) {
          display = "Erro";
          notifyListeners();
          return;
        } else {
          result = num1 / num2;
        }
        break;
    }

    if (result % 1 == 0) {
      display = result.toInt().toString();
    } else {
      display = result.toString();
    }

    operation = "";
    notifyListeners();
  }

  void deleteDigit() {
    if (display.isNotEmpty) {
      display = display.substring(0, display.length - 1);
      notifyListeners();
    }
  }
}
