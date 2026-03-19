import 'package:cat_diet_planner/features/cat_profile/services/guided_bcs_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('assessment is null until all questionnaire answers are present', () {
    final result = GuidedBcsService.assess(const {'ribs': 1, 'waist': 1});
    expect(result, isNull);
  });

  test('assessment suggests BCS 4-5 for balanced ideal answers', () {
    final result = GuidedBcsService.assess(const {
      'ribs': 1,
      'waist': 1,
      'tuck': 1,
      'lumbar': 1,
    });

    expect(result, isNotNull);
    expect(result!.rangeLabel, 'BCS 4-5');
    expect(result.suggestedScore, 5);
    expect(result.recommendation.goal, 'maintenance');
  });

  test('assessment suggests BCS 7+ for strongly overweight answers', () {
    final result = GuidedBcsService.assess(const {
      'ribs': 2,
      'waist': 2,
      'tuck': 2,
      'lumbar': 2,
    });

    expect(result, isNotNull);
    expect(result!.rangeLabel, 'BCS 7+');
    expect(result.suggestedScore, 7);
    expect(result.recommendation.goal, 'loss');
  });

  test('assessment suggests BCS 1-3 for strongly lean answers', () {
    final result = GuidedBcsService.assess(const {
      'ribs': 0,
      'waist': 0,
      'tuck': 0,
      'lumbar': 0,
    });

    expect(result, isNotNull);
    expect(result!.rangeLabel, 'BCS 1-3');
    expect(result.suggestedScore, 3);
    expect(result.recommendation.goal, 'gain');
  });
}
