import 'package:hive_flutter/hive_flutter.dart';
import '../models/cat_group.dart';
import '../models/cat_profile.dart';
import '../models/diet_plan.dart';
import '../models/food_item.dart';
import '../models/group_diet_plan.dart';
import '../models/weight_record.dart';

class HiveService {
  // Boxes declaradas como late para garantir a inicialização antes do uso
  static late Box<dynamic> appSettingsBox;
  static late Box<CatGroup> catGroupsBox;
  static late Box<CatProfile> catsBox;
  static late Box<DietPlan> dietPlansBox;
  static late Box<FoodItem> foodsBox;
  static late Box<GroupDietPlan> groupDietPlansBox;
  static late Box<WeightRecord> weightsBox;
  static late Box<Map<dynamic, dynamic>> mealsBox;

  /// Inicializa o Hive, registra os adaptadores e abre as boxes necessárias.
  static Future<void> init() async {
    // 1. Inicializa o Hive para Flutter (define o caminho de armazenamento)
    await Hive.initFlutter();

    // 2. Registro dos Adapters gerados pelo build_runner
    // Os IDs devem corresponder aos typeId definidos nos modelos
    Hive.registerAdapter(CatProfileAdapter()); // typeId: 0
    Hive.registerAdapter(FoodItemAdapter()); // typeId: 1
    Hive.registerAdapter(WeightRecordAdapter()); // typeId: 2
    Hive.registerAdapter(DietPlanAdapter()); // typeId: 3
    Hive.registerAdapter(CatGroupAdapter()); // typeId: 4
    Hive.registerAdapter(GroupDietPlanAdapter()); // typeId: 5

    // 3. Abertura das Boxes (equivalente a tabelas no SQL)
    appSettingsBox = await Hive.openBox<dynamic>('app_settings');
    catGroupsBox = await Hive.openBox<CatGroup>('cat_groups');
    catsBox = await Hive.openBox<CatProfile>('cats');
    dietPlansBox = await Hive.openBox<DietPlan>('diet_plans');
    foodsBox = await Hive.openBox<FoodItem>('foods');
    groupDietPlansBox = await Hive.openBox<GroupDietPlan>('group_diet_plans');
    weightsBox = await Hive.openBox<WeightRecord>('weights');
    // Usamos Map para refeições para permitir flexibilidade no histórico diário
    mealsBox = await Hive.openBox<Map<dynamic, dynamic>>('meals');
  }

  /// Método utilitário para fechar todas as instâncias se necessário (ex: em testes)
  static Future<void> close() async {
    await Hive.close();
  }
}
