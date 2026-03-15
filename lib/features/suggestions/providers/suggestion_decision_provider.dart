import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SuggestionDecision { accepted, deferred, ignored }

class SuggestionDecisionNotifier
    extends StateNotifier<Map<String, SuggestionDecision>> {
  SuggestionDecisionNotifier() : super(const {});

  void accept(String suggestionId) {
    state = {...state, suggestionId: SuggestionDecision.accepted};
  }

  void defer(String suggestionId) {
    state = {...state, suggestionId: SuggestionDecision.deferred};
  }

  void ignore(String suggestionId) {
    state = {...state, suggestionId: SuggestionDecision.ignored};
  }

  void clear(String suggestionId) {
    final next = {...state}..remove(suggestionId);
    state = next;
  }
}

final suggestionDecisionProvider =
    StateNotifierProvider<
      SuggestionDecisionNotifier,
      Map<String, SuggestionDecision>
    >((ref) {
      return SuggestionDecisionNotifier();
    });
