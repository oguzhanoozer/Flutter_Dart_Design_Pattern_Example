import 'package:logger/logger.dart';

class Customer {
  final String name;

  Customer(this.name);
}

class CreateCustomerAccount {
  void createCreditCard(Customer customer) {
    Logger().d("${customer.name} account was created");
  }
}

class BlackListChecker {
  bool checkEmployeeIsInBlackList(Customer customer) {
    // if customer in list, return false;
    return true;
  }
}

class CreditCardFacade {
  void CreateCreditCard(Customer customer) {
    CreateCustomerAccount createCustomerAccount = CreateCustomerAccount();
    BlackListChecker blackListChecker = BlackListChecker();
    if (blackListChecker.checkEmployeeIsInBlackList(customer)) {
      createCustomerAccount.createCreditCard(customer);
    }
  }
}

void main(List<String> args) {
  Customer customer = Customer("Oğuzhan");
  CreditCardFacade creditCardFacade = CreditCardFacade();
  creditCardFacade.CreateCreditCard(customer);
}
