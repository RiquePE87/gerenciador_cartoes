import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/bindings/model_binding.dart';
import 'package:gerenciador_cartoes/routes/app_pages.dart';
import 'package:gerenciador_cartoes/screens/home_screen.dart';
import 'package:get/get.dart';

void main() => runApp(GetMaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: Routes.INITIAL,
  getPages: AppPages.routes,
  initialBinding: ModelBinding(), // dependencias iniciais
  theme: ThemeData(
      backgroundColor: Colors.purple.shade500,
      primaryColor: Colors.purple,
      iconTheme: IconThemeData(color: Colors.white)), //Tema personalizado app
  defaultTransition: Transition.fadeIn, // Transição de telas padrão
  home: HomeScreen(), // Page inicial
  locale: Locale('pt', 'BR'), // Língua padrão// Suas chaves contendo as traduções<map>
));

