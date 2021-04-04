import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

class ModelBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ModelController>(() => ModelController(dbRepository: DbRepository()));
    // TODO: implement dependencies
  }

}