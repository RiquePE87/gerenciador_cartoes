import 'package:gerenciador_cartoes/screens/dialogs/credit_card_dialog.dart';
import 'package:gerenciador_cartoes/screens/home_screen.dart';
import 'package:gerenciador_cartoes/screens/owner_screen.dart';
import 'package:get/get.dart';
part './app_routes.dart';

class AppPages{

  static final routes = [
    GetPage(name: Routes.INITIAL, page:()=> HomeScreen()),
    GetPage(name: Routes.CREDIT_CARD_DETAILS, page: ()=> CreditCardScreen()),
    GetPage(name: Routes.OWNER_SCREEN, page: ()=> OwnerScreen(), transition: Transition.fadeIn)
  ];
}