class GuidedBcsReference {
  const GuidedBcsReference({
    required this.score,
    required this.title,
    required this.visualCue,
  });

  final int score;
  final String title;
  final String visualCue;
}

class GuidedBcsOption {
  const GuidedBcsOption({
    required this.value,
    required this.title,
    required this.description,
  });

  final int value;
  final String title;
  final String description;
}

class GuidedBcsQuestion {
  const GuidedBcsQuestion({
    required this.id,
    required this.prompt,
    required this.helper,
    required this.options,
  });

  final String id;
  final String prompt;
  final String helper;
  final List<GuidedBcsOption> options;
}

class GuidedBcsAssessmentResult {
  const GuidedBcsAssessmentResult({
    required this.rangeLabel,
    required this.suggestedScore,
    required this.summary,
    required this.explanation,
  });

  final String rangeLabel;
  final int suggestedScore;
  final String summary;
  final String explanation;
}

class GuidedBcsService {
  static const List<GuidedBcsReference> references = [
    GuidedBcsReference(
      score: 1,
      title: 'Emaciated',
      visualCue: 'Very sharp waist',
    ),
    GuidedBcsReference(
      score: 2,
      title: 'Very thin',
      visualCue: 'Ribs and spine obvious',
    ),
    GuidedBcsReference(
      score: 3,
      title: 'Underweight',
      visualCue: 'Minimal fat cover',
    ),
    GuidedBcsReference(
      score: 4,
      title: 'Lean ideal',
      visualCue: 'Waist easy to see',
    ),
    GuidedBcsReference(
      score: 5,
      title: 'Ideal',
      visualCue: 'Ribs felt with light cover',
    ),
    GuidedBcsReference(
      score: 6,
      title: 'Slightly heavy',
      visualCue: 'Waist less distinct',
    ),
    GuidedBcsReference(
      score: 7,
      title: 'Heavy',
      visualCue: 'Rounded belly line',
    ),
    GuidedBcsReference(
      score: 8,
      title: 'Obese',
      visualCue: 'Fat pads easy to notice',
    ),
    GuidedBcsReference(
      score: 9,
      title: 'Grossly obese',
      visualCue: 'No waist, heavy abdominal fat',
    ),
  ];

  static const List<GuidedBcsQuestion> questions = [
    GuidedBcsQuestion(
      id: 'ribs',
      prompt: 'How easy is it to feel the ribs?',
      helper: 'Use light pressure over the ribcage, not just a visual check.',
      options: [
        GuidedBcsOption(
          value: 0,
          title: 'Very easy',
          description: 'Ribs feel sharp or have very little fat cover.',
        ),
        GuidedBcsOption(
          value: 1,
          title: 'Easy with light cover',
          description: 'Ribs are easy to feel but not prominent.',
        ),
        GuidedBcsOption(
          value: 2,
          title: 'Hard to feel',
          description: 'Ribs are buried under obvious fat cover.',
        ),
      ],
    ),
    GuidedBcsQuestion(
      id: 'waist',
      prompt: 'Looking from above, how visible is the waist?',
      helper: 'Stand over the cat and inspect the body behind the ribs.',
      options: [
        GuidedBcsOption(
          value: 0,
          title: 'Very visible',
          description: 'A strong hourglass shape is obvious from above.',
        ),
        GuidedBcsOption(
          value: 1,
          title: 'Visible',
          description: 'A gentle waist is visible without looking extreme.',
        ),
        GuidedBcsOption(
          value: 2,
          title: 'Barely visible',
          description: 'The body looks broad or straight from above.',
        ),
      ],
    ),
    GuidedBcsQuestion(
      id: 'tuck',
      prompt: 'What does the belly line look like from the side?',
      helper: 'Focus on abdominal tuck versus a hanging or rounded belly.',
      options: [
        GuidedBcsOption(
          value: 0,
          title: 'Strong tuck',
          description: 'The abdomen rises sharply after the ribcage.',
        ),
        GuidedBcsOption(
          value: 1,
          title: 'Gentle tuck',
          description: 'There is a mild upward tuck or a mostly level line.',
        ),
        GuidedBcsOption(
          value: 2,
          title: 'Rounded or hanging',
          description: 'The belly hangs low or has a heavy abdominal pouch.',
        ),
      ],
    ),
    GuidedBcsQuestion(
      id: 'lumbar',
      prompt: 'How much fat cover can you feel over the lower back?',
      helper: 'Run your hand over the lumbar area and base of the spine.',
      options: [
        GuidedBcsOption(
          value: 0,
          title: 'Very little',
          description: 'Bones are easy to feel and fat cover is minimal.',
        ),
        GuidedBcsOption(
          value: 1,
          title: 'Light cover',
          description: 'There is a smooth layer without thick padding.',
        ),
        GuidedBcsOption(
          value: 2,
          title: 'Heavy cover',
          description: 'The lower back feels padded or broad.',
        ),
      ],
    ),
  ];

  static bool isComplete(Map<String, int> answers) {
    return questions.every((question) => answers.containsKey(question.id));
  }

  static GuidedBcsAssessmentResult? assess(Map<String, int> answers) {
    if (!isComplete(answers)) return null;

    final total = questions.fold<int>(
      0,
      (sum, question) => sum + (answers[question.id] ?? 0),
    );

    if (total <= 1) {
      return const GuidedBcsAssessmentResult(
        rangeLabel: 'BCS 1-3',
        suggestedScore: 3,
        summary: 'Likely underweight',
        explanation:
            'Multiple answers point to a very obvious waist, little fat cover, or prominent ribs.',
      );
    }
    if (total <= 4) {
      return const GuidedBcsAssessmentResult(
        rangeLabel: 'BCS 4-5',
        suggestedScore: 5,
        summary: 'Likely ideal',
        explanation:
            'The answers suggest ribs are palpable with light cover and the body shape is still defined.',
      );
    }
    if (total <= 6) {
      return const GuidedBcsAssessmentResult(
        rangeLabel: 'BCS 6',
        suggestedScore: 6,
        summary: 'Slightly above ideal',
        explanation:
            'The body shape looks softer and less defined, but not yet strongly overweight.',
      );
    }
    return const GuidedBcsAssessmentResult(
      rangeLabel: 'BCS 7+',
      suggestedScore: 7,
      summary: 'Likely overweight',
      explanation:
          'Several answers indicate heavy fat cover, weak waist definition, or a hanging belly line.',
    );
  }
}
