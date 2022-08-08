import 'package:logger/logger.dart';

class StockManager {
  final String name;
  final int quantity;

  StockManager(this.name, this.quantity);

  void buy() {
    Logger().d("${name} is bought");
  }

  void sell() {
    Logger().d("${name} is sold");
  }
}

abstract class IOrderCommand {
  void execute();
}

class BuyStock extends IOrderCommand {
  final StockManager stockManager;

  BuyStock(this.stockManager);

  @override
  void execute() {
    stockManager.buy();
  }
}

class SellStock extends IOrderCommand {
  final StockManager stockManager;

  SellStock(this.stockManager);

  @override
  void execute() {
    stockManager.sell();
  }
}

class StockController {
  late List<IOrderCommand> orderCommand;

  StockController() {
    orderCommand = [];
  }
  void takeOrder(IOrderCommand command) {
    orderCommand.add(command);
  }

  void placeHolder() {
    for (IOrderCommand command in orderCommand) {
      command.execute();
    }
    orderCommand.clear();
  }
}

void main(List<String> args) {
  StockManager stockManager = StockManager("Phone", 300);

  BuyStock buyStock = BuyStock(stockManager);
  SellStock sellStock = SellStock(stockManager);

  StockController stockController = StockController();
  stockController.takeOrder(buyStock);

  stockController.takeOrder(sellStock);

  stockController.takeOrder(sellStock);
  stockController.takeOrder(buyStock);
  stockController.placeHolder();
}
