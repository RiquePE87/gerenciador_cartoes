import 'package:gerenciador_cartoes/screens/card_details_screen.dart';
import 'package:gerenciador_cartoes/screens/dialogs/credit_card_dialog.dart';
import 'package:gerenciador_cartoes/screens/home_screen.dart';
import 'package:gerenciador_cartoes/screens/owner_screen2.dart';
import 'package:get/get.dart';
part './app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
        name: Routes.INITIAL,
        page: () => HomeScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: Routes.CREDIT_CARD_DIALOG,
        page: () => CreditCardDialog(),
        transition: Transition.fadeIn),
    GetPage(
        name: Routes.OWNER_SCREEN,
        page: () => OwnerScreen2(),
        transition: Transition.fadeIn),
    GetPage(
        name: Routes.CREDIT_DETAILS_SCREEN,
        page: () => CardDetailsScreen(),
        transition: Transition.fadeIn),
  ];
}
