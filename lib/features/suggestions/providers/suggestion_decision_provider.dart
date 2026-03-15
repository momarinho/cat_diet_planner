import 'dart:async';

import 'package:cat_diet_planner/features/suggestions/services/suggestion_decision_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SuggestionDecision { accepted, deferred, ignored }

final suggestionDecisionServiceProvider = Provider<SuggestionDecisionService>((
  ref,
) {
  return SuggestionDecisionService();
});

class SuggestionDecisionNotifier
    extends StateNotifier<Map<String, SuggestionDecision>> {
  SuggestionDecisionNotifier(this._service) : super(_service.read());

  final SuggestionDecisionService _service;

  void accept(String suggestionId) {
    state = {...state, suggestionId: SuggestionDecision.accepted};
    unawaited(_service.save(state));
  }

  void defer(String suggestionId) {
    state = {...state, suggestionId: SuggestionDecision.deferred};
    unawaited(_service.save(state));
  }

  void ignore(String suggestionId) {
    state = {...state, suggestionId: SuggestionDecision.ignored};
    unawaited(_service.save(state));
  }

  void clear(String suggestionId) {
    final next = {...state}..remove(suggestionId);
    state = next;
    unawaited(_service.save(state));
  }
}

final suggestionDecisionProvider =
    StateNotifierProvider<
      SuggestionDecisionNotifier,
      Map<String, SuggestionDecision>
    >((ref) {
      return SuggestionDecisionNotifier(
        ref.read(suggestionDecisionServiceProvider),
      );
    });
