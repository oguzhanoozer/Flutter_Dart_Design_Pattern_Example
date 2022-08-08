// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class Pizza {
  late String description;
  String getDescription();
  double getPrice();
}

class PizzaBase extends Pizza {
  PizzaBase(String description) {
    this.description = description;
  }

  @override
  String getDescription() {
    return description;
  }

  @override
  double getPrice() {
    return 3.0;
  }
}

abstract class PizzaDecorator extends Pizza {
  final Pizza pizza;

  PizzaDecorator(this.pizza);
  @override
  String getDescription() {
    return pizza.description;
  }

  @override
  double getPrice() {
    return pizza.getPrice();
  }
}

class Basil extends PizzaDecorator {
  Basil(Pizza pizza) : super(pizza) {
    description = "Basil";
  }
  @override
  String getDescription() {
    return "${pizza.getDescription()}\n - $description";
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.2;
  }
}

class Mozzorella extends PizzaDecorator {
  Mozzorella(Pizza pizza) : super(pizza) {
    description = "Mozzorella";
  }
  @override
  String getDescription() {
    return "${pizza.getDescription()}\n - $description";
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.5;
  }
}

class OliveOil extends PizzaDecorator {
  OliveOil(Pizza pizza) : super(pizza) {
    description = "OliveOil";
  }
  @override
  String getDescription() {
    return "${pizza.getDescription()}\n - $description";
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.1;
  }
}

class Oregano extends PizzaDecorator {
  Oregano(Pizza pizza) : super(pizza) {
    description = "Oregano";
  }
  @override
  String getDescription() {
    return "${pizza.getDescription()}\n - $description";
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.2;
  }
}

class Pecorino extends PizzaDecorator {
  Pecorino(Pizza pizza) : super(pizza) {
    description = "Pecorino";
  }
  @override
  String getDescription() {
    return "${pizza.getDescription()}\n - $description";
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 1.5;
  }
}

class Sauce extends PizzaDecorator {
  Sauce(Pizza pizza) : super(pizza) {
    description = "Sauce";
  }
  @override
  String getDescription() {
    return "${pizza.getDescription()}\n - $description";
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.3;
  }
}

class Pepperoni extends PizzaDecorator {
  Pepperoni(Pizza pizza) : super(pizza) {
    description = "Pepperoni";
  }
  @override
  String getDescription() {
    return "${pizza.getDescription()}\n - $description";
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.5;
  }
}

class PizzaToppingData {
  final String label;
  bool selected = false;

  PizzaToppingData(this.label);

  void setSelected({required bool isSelected}) {
    selected = isSelected;
  }
}

class PizzaMenu {
  final Map<int, PizzaToppingData> _pizzaToppingDataMap = {
    1: PizzaToppingData("Basil"),
    2: PizzaToppingData("Mozzarella"),
    3: PizzaToppingData("Olive Oil"),
    4: PizzaToppingData("Oregano"),
    5: PizzaToppingData("Pecorino"),
    6: PizzaToppingData("Pepperoni"),
    7: PizzaToppingData("Suauce"),
  };
  Map<int, PizzaToppingData> get getPizzaToppingDataMap => _pizzaToppingDataMap;

  Pizza getPizza(int index, Map<int, PizzaToppingData> pizzaToppingDataMap) {
    switch (index) {
      case 0:
        return _getMargeherita();
      case 1:
        return _getPepperoni();
      case 2:
        return _getCustom(pizzaToppingDataMap);
    }
    throw Exception("Index of ${index} does not exist");
  }

  Pizza _getMargeherita() {
    Pizza pizza = PizzaBase("Pizza Margherita");
    pizza = Sauce(pizza);
    pizza = Mozzorella(pizza);
    pizza = Basil(pizza);
    pizza = Oregano(pizza);
    pizza = Pecorino(pizza);
    pizza = OliveOil(pizza);

    return pizza;
  }

  Pizza _getPepperoni() {
    Pizza pizza = PizzaBase("Pizza Pepperoni");
    pizza = Sauce(pizza);
    pizza = Mozzorella(pizza);
    pizza = Pepperoni(pizza);
    pizza = Oregano(pizza);
    return pizza;
  }

  Pizza _getCustom(Map<int, PizzaToppingData> pizzaToppingsDataMap) {
    Pizza pizza = PizzaBase('Custom Pizza');

    if (pizzaToppingsDataMap[1]!.selected) {
      pizza = Basil(pizza);
    }

    if (pizzaToppingsDataMap[2]!.selected) {
      pizza = Mozzorella(pizza);
    }

    if (pizzaToppingsDataMap[3]!.selected) {
      pizza = OliveOil(pizza);
    }

    if (pizzaToppingsDataMap[4]!.selected) {
      pizza = Oregano(pizza);
    }

    if (pizzaToppingsDataMap[5]!.selected) {
      pizza = Pecorino(pizza);
    }

    if (pizzaToppingsDataMap[6]!.selected) {
      pizza = Pepperoni(pizza);
    }

    if (pizzaToppingsDataMap[7]!.selected) {
      pizza = Sauce(pizza);
    }

    return pizza;
  }
}

class DecoratorView extends StatefulWidget {
  DecoratorView({Key? key}) : super(key: key);

  @override
  State<DecoratorView> createState() => _DecoratorViewState();
}

class _DecoratorViewState extends State<DecoratorView> {
  final PizzaMenu pizzaMenu = PizzaMenu();

  late Map<int, PizzaToppingData> _pizzaToppingDataMap;
  late Pizza _pizza;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pizzaToppingDataMap = pizzaMenu.getPizzaToppingDataMap;
    _pizza = pizzaMenu.getPizza(_selectedIndex, _pizzaToppingDataMap);
  }

  void _onSelectedIndexChanged(int? index) {
    _setSelectedIndex(index!);
    _setSelectedPizza(index);
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCustomPizzaChipSelected(int index, bool? selected) {
    _setChipSelected(index, selected!);
    _setSelectedPizza(_selectedIndex);
  }

  void _setChipSelected(int index, bool selected) {
    setState(() {
      _pizzaToppingDataMap[index]!.setSelected(isSelected: selected);
    });
  }

  void _setSelectedPizza(int index) {
    setState(() {
      _pizza = pizzaMenu.getPizza(index, _pizzaToppingDataMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Select your pizza:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            PizzaSelection(
              selectedIndex: _selectedIndex,
              onChanged: _onSelectedIndexChanged,
            ),
            if (_selectedIndex == 2)
              CustomPizzaSelection(
                pizzaToppingsDataMap: _pizzaToppingDataMap,
                onSelected: _onCustomPizzaChipSelected,
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Pizza details:',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Text(
                  _pizza.getDescription(),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text('Price: \$${_pizza.getPrice().toStringAsFixed(2)}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

const _labels = ['Pizza Margherita', 'Pizza Pepperoni', 'Custom'];

class PizzaSelection extends StatelessWidget {
  final int selectedIndex;
  final ValueSetter<int?> onChanged;

  const PizzaSelection({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var i = 0; i < _labels.length; i++)
          RadioListTile(
            title: Text(_labels[i]),
            value: i,
            groupValue: selectedIndex,
            selected: i == selectedIndex,
            activeColor: Colors.black,
            controlAffinity: ListTileControlAffinity.platform,
            onChanged: onChanged,
          ),
      ],
    );
  }
}

class CustomPizzaSelection extends StatelessWidget {
  Map<int, PizzaToppingData> pizzaToppingsDataMap;
  Function(int, bool?) onSelected;

  CustomPizzaSelection({
    Key? key,
    required this.pizzaToppingsDataMap,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var i = 0; i < pizzaToppingsDataMap.length; i++)
          i == 0
              ? ChoiceChip(
                  label: const Text(
                    'Pizza Base',
                    style: TextStyle(color: Colors.white),
                  ),
                  selected: true,
                  selectedColor: Colors.black,
                  onSelected: (_) {},
                )
              : ChoiceChip(
                  label: Text(
                    pizzaToppingsDataMap[i]!.label,
                    style: TextStyle(
                      color: pizzaToppingsDataMap[i]!.selected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: pizzaToppingsDataMap[i]!.selected,
                  selectedColor: Colors.black,
                  onSelected: (bool? selected) => onSelected(i, selected),
                ),
      ],
    );
  }
}
