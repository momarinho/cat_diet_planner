// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'CatDiet Planner';

  @override
  String get settingsTitle => 'Configuracoes';

  @override
  String get languageSectionTitle => 'Idioma';

  @override
  String get appLanguageTitle => 'Idioma do app';

  @override
  String get localizedContentScopeTitle => 'Escopo do conteudo localizado';

  @override
  String get localizedContentScopeDescription =>
      'Notificacoes e textos de relatorio/compartilhamento agora seguem o idioma selecionado.';

  @override
  String get navDaily => 'Dia';

  @override
  String get navHome => 'Inicio';

  @override
  String get navPlans => 'Planos';

  @override
  String get navHistory => 'Historico';

  @override
  String get routeErrorTitle => 'Erro de rota';

  @override
  String get dashboardTitle => 'Painel';

  @override
  String get activeCatTitle => 'Gato ativo';

  @override
  String get editAction => 'Editar';

  @override
  String catAgeYearsOld(int years) {
    return '$years anos';
  }

  @override
  String get scanFoodAction => 'Escanear alimento';

  @override
  String get logWeightAction => 'Registrar peso';

  @override
  String get dailySummaryTitle => 'Resumo diario';

  @override
  String get todayLabel => 'Hoje';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get calorieIntakeLabel => 'CONSUMO CALORICO';

  @override
  String get createPlanToUnlockDailySummary =>
      'Crie um plano para liberar seu resumo diario';

  @override
  String get todayFullyCompleted => 'Hoje foi totalmente concluido';

  @override
  String remainingCaloriesForMeal(int kcal, String meal) {
    return '$kcal kcal restantes para $meal';
  }

  @override
  String get mealTimelineTitle => 'Linha do tempo das refeicoes';

  @override
  String get viewPlanAction => 'Ver plano';

  @override
  String get noTimelineYetTitle => 'Sem linha do tempo ainda';

  @override
  String get noTimelineYetDescription =>
      'Salve um plano alimentar para liberar a linha do tempo das refeicoes.';

  @override
  String mealFallbackTitle(int number) {
    return 'Refeicao $number';
  }

  @override
  String mealMarkedPending(String meal) {
    return '$meal marcada como pendente.';
  }

  @override
  String mealMarkedCompleted(String meal) {
    return '$meal marcada como concluida.';
  }

  @override
  String get planInspectorTitle => 'Inspetor de plano';

  @override
  String get groupPlanInspectorTitle => 'Inspetor de plano do grupo';

  @override
  String get previewTab => 'Preview';

  @override
  String get savedTab => 'Salvo';

  @override
  String get noPreviewYetTitle => 'Ainda sem preview';

  @override
  String get noPreviewYetDescription =>
      'Ajuste alimentos ou parametros do plano para gerar um preview.';

  @override
  String get noCatSelectedTitle => 'Nenhum gato selecionado';

  @override
  String get noCatSelectedDescription =>
      'Selecione um gato para inspecionar seus planos salvos.';

  @override
  String get noSavedPlansYetTitle => 'Ainda sem planos salvos';

  @override
  String get noSavedPlansYetDescription =>
      'Salve um plano para inspeciona-lo aqui.';

  @override
  String get noGroupSelectedTitle => 'Nenhum grupo selecionado';

  @override
  String get noGroupSelectedDescription =>
      'Selecione um grupo para inspecionar seu plano salvo.';

  @override
  String get noSavedGroupPlanTitle => 'Sem plano de grupo salvo';

  @override
  String get noSavedGroupPlanDescription =>
      'Salve um plano de grupo para inspeciona-lo aqui.';

  @override
  String get savedIndividualPlanTitle => 'Plano individual salvo';

  @override
  String get savedGroupPlanTitle => 'Plano de grupo salvo';

  @override
  String get planPreviewTitle => 'Preview do plano';

  @override
  String get groupPlanPreviewTitle => 'Preview do plano do grupo';

  @override
  String get savedCoreTargetsTitle => 'Metas centrais';

  @override
  String get savedCoreTargetsSubtitle =>
      'Valores salvos que estao sendo usados por este plano.';

  @override
  String get savedMealTimelineTitle => 'Linha do tempo das refeicoes';

  @override
  String get savedMealTimelineSubtitle =>
      'Agenda salva e divisao de porcao por refeicao.';

  @override
  String get savedPlanDetailsTitle => 'Detalhes do plano';

  @override
  String get savedPlanDetailsSubtitle =>
      'Contexto operacional, notas e configuracao salva.';

  @override
  String get previewCoreTargetsTitle => 'Metas centrais';

  @override
  String get previewCoreTargetsSubtitle =>
      'Numeros que serao usados quando este rascunho for salvo.';

  @override
  String get previewMealTimelineTitle => 'Linha do tempo das refeicoes';

  @override
  String get previewMealTimelineSubtitle =>
      'Cada refeicao com horario e porcao exata.';

  @override
  String get previewPlanDetailsTitle => 'Detalhes do plano';

  @override
  String get previewPlanDetailsSubtitle =>
      'Contexto que afeta a execucao, mas e facil perder.';

  @override
  String get customPlanLabel => 'Plano personalizado';

  @override
  String startsTag(String date) {
    return 'Comeca $date';
  }

  @override
  String mealsPerDayTag(int count) {
    return '$count refeicoes/dia';
  }

  @override
  String catsCountTag(int count) {
    return '$count gatos';
  }

  @override
  String get activePlanTag => 'Plano ativo';

  @override
  String get metricDailyGoal => 'Meta diaria';

  @override
  String get metricFoodPerDay => 'Alimento por dia';

  @override
  String get metricAveragePerMeal => 'Media por refeicao';

  @override
  String get metricServingUnit => 'Unidade de porcao';

  @override
  String get metricPerCat => 'Por gato';

  @override
  String get metricGroupTotal => 'Total do grupo';

  @override
  String get metricGroupPerDay => 'Grupo por dia';

  @override
  String get metricGroupPerMeal => 'Grupo por refeicao';

  @override
  String get metricSavedAt => 'Salvo em';

  @override
  String get metricOverrides => 'Overrides';

  @override
  String get metricFoods => 'Alimentos';

  @override
  String get metricNotes => 'Notas';

  @override
  String get metricStarts => 'Comeca';

  @override
  String get metricDistribution => 'Distribuicao';

  @override
  String get helperEnergyTarget => 'Meta energetica';

  @override
  String get helperTotalPortion => 'Porcao total';

  @override
  String get helperBaselineSplit => 'Divisao base';

  @override
  String get helperDisplayUnit => 'Unidade exibida';

  @override
  String get helperEnergyTargetPerCat => 'Meta energetica por gato';

  @override
  String get helperCombinedEnergyTarget => 'Meta energetica combinada';

  @override
  String get helperAverageFeedingSlot => 'Media por horario';

  @override
  String get noActiveOverrides => 'Sem overrides ativos';

  @override
  String activeOverridesCount(int count) {
    return '$count overrides ativos';
  }

  @override
  String get noNotesYet => 'Sem notas ainda';

  @override
  String get equalSplitLabel => 'Divisao igual';

  @override
  String unequalSplitLabel(int count) {
    return 'Divisao desigual ($count gatos)';
  }

  @override
  String get activePlanLabelText => 'Plano ativo';

  @override
  String usePlanAction(String date) {
    return 'Usar $date';
  }

  @override
  String get deleteActivePlanAction => 'Excluir plano ativo';

  @override
  String get scheduledFeedingSlotCaption => 'Horario programado de alimentacao';

  @override
  String plusMoreFoods(int count) {
    return '+ $count a mais';
  }

  @override
  String get plansTitle => 'Planos';

  @override
  String get planInspectorTooltip => 'Preview e plano salvo';

  @override
  String get buildPlanTitle => 'Montar plano';

  @override
  String get individualPlanMode => 'Individual';

  @override
  String get groupPlanMode => 'Grupo';

  @override
  String get catProfileLabel => 'Perfil do gato';

  @override
  String get groupLabel => 'Grupo';

  @override
  String groupWithCats(String group, int count) {
    return '$group ($count gatos)';
  }

  @override
  String get targetKcalPerCatPerDayLabel => 'Meta de kcal por gato / dia';

  @override
  String get createGroupAction => 'Criar grupo';

  @override
  String mealsPerDayChip(int count) {
    return '$count refeicoes/dia';
  }

  @override
  String get planStartDateTitle => 'Data de inicio do plano';

  @override
  String startsOnLabel(String date) {
    return 'Comeca em $date';
  }

  @override
  String get portionUnitTitle => 'Unidade da porcao';

  @override
  String get unitLabel => 'Unidade';

  @override
  String get gramsPerUnitLabel => 'Gramas por unidade';

  @override
  String get weekendAlternativeTitle => 'Alternativa para fim de semana';

  @override
  String get weekendAlternativeDescription =>
      'Aplicar um fator diferente de kcal/porcao no sabado e domingo.';

  @override
  String get weekendKcalFactorLabel => 'Fator de kcal no fim de semana (%)';

  @override
  String get byWeekdayTitle => 'Por dia da semana';

  @override
  String get byWeekdayDescription =>
      'Ative dias especificos e defina um fator de kcal/porcao para cada dia.';

  @override
  String get factorPercentLabel => 'Fator %';

  @override
  String get operationalNotesLabel => 'Notas operacionais';

  @override
  String get mealLabelsTitle => 'Nomes das refeicoes';

  @override
  String mealNameLabel(int count) {
    return 'Nome da refeicao $count';
  }

  @override
  String get mealPortionsTitle => 'Porcoes por refeicao';

  @override
  String get mealPortionsDescription =>
      'Defina a porcentagem da porcao diaria servida em cada refeicao. O app normaliza o total para 100%.';

  @override
  String mealShareLabel(String meal) {
    return 'Participacao de $meal (%)';
  }

  @override
  String get mealScheduleTitle => 'Horario das refeicoes';

  @override
  String get mealScheduleDescription =>
      'Escolha o horario de cada refeicao. Daily e Home usarao esta agenda.';

  @override
  String get suggestionsTitle => 'Sugestoes';

  @override
  String get noCatProfilesAvailableTitle => 'Nenhum perfil de gato disponivel';

  @override
  String get noCatProfilesAvailableMessage =>
      'Crie um perfil de gato antes de montar um plano individual.';

  @override
  String get noGroupsAvailableTitle => 'Nenhum grupo disponivel';

  @override
  String get noGroupsAvailableMessage =>
      'Crie um grupo antes de montar um plano compartilhado.';

  @override
  String get availableFoodsTitle => 'Alimentos disponiveis';

  @override
  String get noFoodsAvailableTitle => 'Nenhum alimento disponivel';

  @override
  String get noFoodsAvailableDescription =>
      'Adicione alimentos em Food Database antes de criar um plano.';

  @override
  String get multipleFoodsTitle => 'Multiplos alimentos';

  @override
  String get multipleFoodsDescription =>
      'Permitir selecionar varios alimentos para o plano';

  @override
  String get unknownBrand => 'Marca desconhecida';

  @override
  String get savePlanAction => 'Salvar plano';

  @override
  String get saveGroupPlanAction => 'Salvar plano do grupo';

  @override
  String get savingLabel => 'Salvando...';

  @override
  String get planDeletedMessage => 'Plano excluido.';

  @override
  String planSavedForCatMessage(String name) {
    return 'Plano salvo para $name';
  }

  @override
  String planSavedForGroupMessage(String name) {
    return 'Plano salvo para $name';
  }

  @override
  String get enterValidKcalPerCatMessage =>
      'Digite uma meta de kcal valida por gato.';

  @override
  String get mondayLabel => 'Segunda-feira';

  @override
  String get tuesdayLabel => 'Terca-feira';

  @override
  String get wednesdayLabel => 'Quarta-feira';

  @override
  String get thursdayLabel => 'Quinta-feira';

  @override
  String get fridayLabel => 'Sexta-feira';

  @override
  String get saturdayLabel => 'Sabado';

  @override
  String get sundayLabel => 'Domingo';

  @override
  String dayFallbackLabel(int weekday) {
    return 'Dia $weekday';
  }

  @override
  String get noActiveSuggestionsDescription =>
      'Nenhuma sugestao ativa agora. Continue registrando refeicoes e peso para melhorar as orientacoes.';

  @override
  String get confirmPlanChangeTitle => 'Confirmar mudanca no plano';

  @override
  String applySuggestionAfterReview(String catName) {
    return 'Aplique esta sugestao a $catName somente apos revisao.';
  }

  @override
  String get responsiblePersonLabel => 'Pessoa responsavel';

  @override
  String get typeWhoApprovedHint => 'Digite quem aprovou esta mudanca';

  @override
  String get approvalIdentityRequired =>
      'A identificacao do aprovador e obrigatoria.';

  @override
  String get cancelAction => 'Cancelar';

  @override
  String get confirmAction => 'Confirmar';

  @override
  String get planUpdatedAfterConfirmation =>
      'Plano atualizado apos confirmacao.';

  @override
  String get suggestionRecordedWithoutPlanChanges =>
      'Sugestao registrada sem mudancas no plano.';

  @override
  String suggestionConfidenceLabel(String value) {
    return 'Confianca $value';
  }

  @override
  String get suggestionAcceptedStatus => 'Aceita';

  @override
  String get suggestionDeferredStatus => 'Adiada';

  @override
  String get suggestionIgnoredStatus => 'Ignorada';

  @override
  String get whyThisSuggestionTitle => 'Por que esta sugestao:';

  @override
  String get acceptAction => 'Aceitar';

  @override
  String get deferAction => 'Adiar';

  @override
  String get ignoreAction => 'Ignorar';

  @override
  String get restoreAction => 'Restaurar';

  @override
  String get autoApplyDisabledMessage =>
      'A aplicacao automatica esta desativada. Mudancas no plano sempre exigem confirmacao.';

  @override
  String get suggestionTypeKcal => 'Kcal';

  @override
  String get suggestionTypeSchedule => 'Horario';

  @override
  String get suggestionTypePortions => 'Porcoes';

  @override
  String get suggestionTypePreventiveAlert => 'Alerta preventivo';

  @override
  String get suggestionTypeClinicalWatch => 'Alerta clinico';

  @override
  String get reasonWeightTrendUp =>
      'A tendencia recente de peso esta aumentando';

  @override
  String get reasonWeightTrendDown =>
      'A tendencia recente de peso esta diminuindo';

  @override
  String get reasonOutOfGoalMax => 'O peso esta acima da faixa configurada';

  @override
  String get reasonOutOfGoalMin => 'O peso esta abaixo da faixa configurada';

  @override
  String get reasonApproachingGoalMax =>
      'A tendencia esta se aproximando do limite superior da meta';

  @override
  String get reasonApproachingGoalMin =>
      'A tendencia esta se aproximando do limite inferior da meta';

  @override
  String get reasonAdherenceLow => 'A adesao das refeicoes esta abaixo da meta';

  @override
  String get reasonRefusalFrequent => 'Eventos de recusa sao frequentes';

  @override
  String get reasonDelayedFrequent => 'Refeicoes atrasadas sao frequentes';

  @override
  String get reasonAppetiteReduced =>
      'Reducao de apetite foi registrada recentemente';

  @override
  String get reasonAppetitePoor => 'Baixo apetite foi registrado recentemente';

  @override
  String get reasonVomitFrequent =>
      'Eventos frequentes de vomito foram registrados';

  @override
  String get reasonStoolDiarrhea => 'Eventos de diarreia foram registrados';

  @override
  String get reasonClinicalConditionPresent =>
      'Condicoes clinicas estao configuradas no perfil';

  @override
  String get reasonWeightAlertTriggered =>
      'Alertas de peso foram disparados recentemente';

  @override
  String get reasonLowEvidence =>
      'Dados limitados disponiveis (baixa evidencia)';

  @override
  String dietWeightRangeError(String min, String max) {
    return 'O peso deve estar entre $min e $max kg.';
  }

  @override
  String dietAgeRangeError(String min, String max) {
    return 'A idade deve estar entre $min e $max meses.';
  }

  @override
  String get dietFoodCaloriesPositiveError =>
      'As calorias do alimento devem ser maiores que zero.';

  @override
  String dietMealsRangeError(String min, String max) {
    return 'As refeicoes por dia devem estar entre $min e $max.';
  }

  @override
  String get dietWeightPositiveError => 'O peso deve ser maior que zero.';

  @override
  String get dietMealsPositiveError =>
      'As refeicoes por dia devem ser maiores que zero.';

  @override
  String portionUnknownUnitError(String unit) {
    return 'Unidade de porcao desconhecida \"$unit\".';
  }

  @override
  String portionZeroEquivalentError(String unit) {
    return 'A unidade \"$unit\" tem equivalente em gramas igual a zero.';
  }

  @override
  String get noActivePlanAvailableForCat =>
      'Nenhum plano ativo disponivel para este gato.';

  @override
  String get noSuggestedPlanChangesAvailableToRevert =>
      'Nenhuma mudanca sugerida disponivel para reverter.';

  @override
  String get lastSuggestedChangeReverted =>
      'A ultima mudanca sugerida foi revertida.';

  @override
  String get suggestionDataIncomplete =>
      'Os dados da sugestao estao incompletos.';

  @override
  String get suggestedKcalChangeExceedsSafeBand =>
      'A mudanca sugerida de kcal excede a faixa segura de ajuste.';

  @override
  String get suggestedKcalTargetOutsideSafeRange =>
      'A meta sugerida de kcal esta fora da faixa segura permitida.';

  @override
  String get unableToRecalculatePortionSafely =>
      'Nao foi possivel recalcular a porcao com seguranca.';

  @override
  String get scheduleChangeExceedsSafeShiftLimit =>
      'A mudanca de horario excede o limite seguro de deslocamento.';

  @override
  String get portionRedistributionInvalidForActivePlan =>
      'A redistribuicao de porcao e invalida para o plano ativo.';

  @override
  String get portionShiftExceedsSafeRedistributionLimit =>
      'O deslocamento de porcao excede o limite seguro de redistribuicao.';

  @override
  String get portionRedistributionFailedSafetyValidation =>
      'A redistribuicao de porcao falhou na validacao de seguranca.';

  @override
  String summaryTargetKcalPerDayChange(
    String fromValue,
    String toValue,
    String delta,
  ) {
    return 'Meta kcal/dia: $fromValue -> $toValue ($delta)';
  }

  @override
  String summaryDailyPortionChange(String fromValue, String toValue) {
    return 'Porcao diaria: $fromValue -> $toValue';
  }

  @override
  String summaryMealTimeChange(String meal, String fromValue, String toValue) {
    return '$meal: $fromValue -> $toValue';
  }

  @override
  String summaryMealPortionChange(
    String meal,
    String fromValue,
    String toValue,
  ) {
    return '$meal: $fromValue -> $toValue';
  }

  @override
  String get revertLastSuggestedChangeTitle =>
      'Reverter ultima mudanca sugerida';

  @override
  String get revertLastSuggestedChangeDescription =>
      'Isso restaura o snapshot do plano anterior a ultima mudanca sugerida.';

  @override
  String get typeWhoIsRevertingHint =>
      'Informe quem esta revertendo esta mudanca';

  @override
  String get responsiblePersonRequired =>
      'A identificacao da pessoa responsavel e obrigatoria.';

  @override
  String get revertAction => 'Reverter';

  @override
  String impactRevertedBy(String name) {
    return 'Revertido por $name';
  }

  @override
  String get impactActiveChange => 'Mudanca ativa';

  @override
  String impactBeforeAfterKcal(String beforeValue, String afterValue) {
    return 'Kcal antes/depois: $beforeValue -> $afterValue';
  }

  @override
  String get unknownPersonLabel => 'desconhecido';

  @override
  String get shareMessageTitle => 'Mensagem de compartilhamento';

  @override
  String get shareMessageHint =>
      'Mensagem usada ao compartilhar arquivos de relatorio';

  @override
  String get saveAction => 'Salvar';

  @override
  String get mealReminderTimesTitle => 'Horarios de lembrete de refeicao';

  @override
  String get addTimeAction => 'Adicionar horario';

  @override
  String get saveScheduleAction => 'Salvar agenda';

  @override
  String get generateDemoDataTitle => 'Gerar dados demo';

  @override
  String get generateDemoDataDescription =>
      'Isso vai substituir os dados locais atuais por um cenario pronto para teste com um grupo, um gato individual, alimentos, planos, refeicoes e historico de peso.';

  @override
  String get generateAction => 'Gerar';

  @override
  String demoDataReadyMessage(int groups, int cats, int foods, int schedules) {
    return 'Dados demo prontos: $groups grupo, $cats gato, $foods alimentos, $schedules agendas.';
  }

  @override
  String get clearDemoDataTitle => 'Limpar dados demo';

  @override
  String get clearDemoDataDescription =>
      'Isso vai remover os dados demo locais do app, incluindo gatos, grupos, alimentos, planos, refeicoes e historico.';

  @override
  String get clearAction => 'Limpar';

  @override
  String get localDemoDataClearedMessage => 'Dados demo locais removidos.';

  @override
  String get generateStressDataTitle => 'Gerar dados de teste de estresse';

  @override
  String get generateStressDataDescription =>
      'Isso vai carregar um cenario operacional pesado (ate 10 gatos e 5 grupos) para validar navegacao, listas e rotinas diarias em uso de alto volume.';

  @override
  String stressScenarioReadyMessage(
    int groups,
    int cats,
    int foods,
    int schedules,
  ) {
    return 'Cenario de estresse pronto: $groups grupos, $cats gatos, $foods alimentos, $schedules agendas.';
  }

  @override
  String get customRangeDaysTitle => 'Dias do intervalo personalizado';

  @override
  String customRangeDaysValue(int days) {
    return '$days dias';
  }

  @override
  String get customRangeTitle => 'Intervalo personalizado';

  @override
  String get daysLabel => 'Dias';

  @override
  String get noAcceptedPlanChangesYetTitle =>
      'Nenhuma mudanca de plano aceita ainda';

  @override
  String get noAcceptedPlanChangesYetDescription =>
      'Mudancas aprovadas por sugestao vao registrar quem aceitou, quando e o que mudou.';

  @override
  String get noSuggestionImpactHistoryYetTitle =>
      'Nenhum historico de impacto de sugestoes ainda';

  @override
  String get noSuggestionImpactHistoryYetDescription =>
      'Sugestoes geradas, mudancas aceitas e snapshots de antes/depois serao armazenados aqui.';

  @override
  String get revertLatestSuggestedAdjustmentDescription =>
      'Restaura o snapshot mais recente do plano salvo antes da aplicacao de um ajuste sugerido.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get tryAgainAction => 'Tentar novamente';

  @override
  String get deleteAction => 'Excluir';

  @override
  String get kgUnit => 'kg';

  @override
  String get catsUnit => 'gatos';

  @override
  String get noneOption => 'Nenhum';

  @override
  String get normalOption => 'Normal';

  @override
  String get highOption => 'Alta';

  @override
  String get lowOption => 'Baixa';

  @override
  String get poorOption => 'Ruim';

  @override
  String get reducedOption => 'Reduzido';

  @override
  String get softOption => 'Mole';

  @override
  String get hardOption => 'Duro';

  @override
  String get diarrheaOption => 'Diarreia';

  @override
  String get occasionalOption => 'Ocasional';

  @override
  String get frequentOption => 'Frequente';

  @override
  String get otherOption => 'Outro';

  @override
  String get sedentaryOption => 'Sedentario';

  @override
  String get moderateOption => 'Moderado';

  @override
  String get activeOption => 'Ativo';

  @override
  String get maleOption => 'Macho';

  @override
  String get femaleOption => 'Femea';

  @override
  String get unknownOption => 'Desconhecido';

  @override
  String get maintenanceGoalOption => 'Manutencao';

  @override
  String get weightLossGoalOption => 'Perda de peso';

  @override
  String get weightGainGoalOption => 'Ganho de peso';

  @override
  String get kittenGrowthGoalOption => 'Crescimento do filhote';

  @override
  String get seniorSupportGoalOption => 'Suporte senior';

  @override
  String get recoveryGoalOption => 'Recuperacao';

  @override
  String get postSurgeryGoalOption => 'Pos-cirurgia';

  @override
  String get completedOption => 'Concluido';

  @override
  String get partialOption => 'Parcial';

  @override
  String get delayedOption => 'Atrasado';

  @override
  String get refusedOption => 'Recusado';

  @override
  String get reducedAppetiteOption => 'Apetite reduzido';

  @override
  String get skippedOption => 'Pulado';

  @override
  String get loggedStatus => 'Registrado';

  @override
  String get weightCheckInTitle => 'Check-in de peso';

  @override
  String get noActiveCatTitle => 'Nenhum gato ativo';

  @override
  String get noActiveCatDescription =>
      'Selecione um gato em Home antes de registrar o peso.';

  @override
  String get weightRecordedWithAlertMessage =>
      'Peso registrado com alerta. Revise metas e notas clinicas.';

  @override
  String get weightRecordedMessage => 'Peso registrado.';

  @override
  String get weightNoteSuggestionHighAppetite => 'Muito apetite';

  @override
  String get weightNoteSuggestionEnergetic => 'Energetico';

  @override
  String get weightNoteSuggestionLazyDay => 'Dia preguiçoso';

  @override
  String get weightContextFastingOption => 'Jejum';

  @override
  String get weightContextAfterMealOption => 'Apos refeicao';

  @override
  String get weightContextDifferentScaleOption => 'Balanca diferente';

  @override
  String get noPreviousCheckInLabel => 'Nenhum check-in anterior';

  @override
  String lastCheckInLabel(String date) {
    return 'Ultimo check-in: $date';
  }

  @override
  String recordingNowLabel(String date, String time) {
    return 'Registrando agora: $date as $time';
  }

  @override
  String get lastWeightLabel => 'ULTIMO\nPESO';

  @override
  String get checkInDateTimeTitle => 'Data e hora do check-in';

  @override
  String get currentWeightLabel => 'PESO ATUAL';

  @override
  String get checkInContextTitle => 'Contexto do check-in';

  @override
  String get checkInContextDescription =>
      'Use este contexto para melhorar a interpretacao da tendencia nos relatorios.';

  @override
  String get weightContextLabel => 'Contexto do peso';

  @override
  String get appetiteLabel => 'Apetite';

  @override
  String get stoolLabel => 'Fezes';

  @override
  String get vomitLabel => 'Vomito';

  @override
  String get energyLabel => 'Energia';

  @override
  String get checkInNotesTitle => 'Notas do check-in';

  @override
  String get checkInNotesDescription =>
      'Registre comportamento e acompanhamento clinico desta entrada de peso.';

  @override
  String get weightNotesHint =>
      'Como esta o apetite hoje? Houve mudanca de humor ou energia?';

  @override
  String get clinicalAssessmentStructuredLabel =>
      'Avaliacao clinica (estruturada)';

  @override
  String get clinicalPlanFollowUpLabel => 'Plano clinico / acompanhamento';

  @override
  String get recordWeightAction => 'Registrar peso';

  @override
  String get recordWeightActionUppercase => 'REGISTRAR PESO';

  @override
  String get catProfileTitle => 'Perfil do gato';

  @override
  String get deleteProfileTitle => 'Excluir perfil';

  @override
  String removeProfileMessage(String name) {
    return 'Remover $name do app?';
  }

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get createNewCatProfileTitle => 'Criar um novo perfil de gato';

  @override
  String get catProfileIntroDescription =>
      'Dados pessoais, contexto clinico e metas alimentares em um so lugar.';

  @override
  String get uploadPhotoAction => 'Enviar foto';

  @override
  String get coreProfileSectionTitle => 'Perfil base';

  @override
  String get coreProfileSectionDescription =>
      'Identidade e dados metabolicos usados em todo o app.';

  @override
  String get nameLabel => 'Nome';

  @override
  String get enterCatNameError => 'Informe o nome do gato';

  @override
  String get weightKgLabel => 'Peso (kg)';

  @override
  String get invalidWeightError => 'Peso invalido';

  @override
  String get ageYearsLabel => 'Idade (anos)';

  @override
  String get invalidAgeError => 'Idade invalida';

  @override
  String get neuteredSpayedTitle => 'Castrado / esterilizado';

  @override
  String get neuteredSpayedDescription => 'Afeta a necessidade calorica';

  @override
  String get activityLevelLabel => 'Nivel de atividade';

  @override
  String get goalLabel => 'Objetivo';

  @override
  String get preferredMealsPerDayLabel => 'Refeicoes preferidas por dia';

  @override
  String get manualTargetKcalPerDayOptionalLabel =>
      'Meta manual de kcal/dia (opcional)';

  @override
  String get manualTargetKcalHelperText =>
      'Deixe vazio para manter o calculo automatico';

  @override
  String get invalidKcalTargetError => 'Meta de kcal invalida';

  @override
  String get clinicalContextSectionTitle => 'Contexto clinico';

  @override
  String get clinicalContextSectionDescription =>
      'Campos opcionais que refinam recomendacoes e acompanhamento clinico.';

  @override
  String get idealWeightOptionalLabel => 'Peso ideal (kg) (opcional)';

  @override
  String get idealWeightHelperText =>
      'Opcional: usado para refinar sugestoes de kcal';

  @override
  String get invalidIdealWeightError => 'Peso ideal invalido';

  @override
  String get bodyConditionScoreLabel => 'Escore de condicao corporal (1-9)';

  @override
  String get sexLabel => 'Sexo';

  @override
  String get breedOptionalLabel => 'Raca (opcional)';

  @override
  String get dateOfBirthOptionalLabel => 'Data de nascimento (opcional)';

  @override
  String get customActivityLevelOptionalLabel =>
      'Nivel de atividade customizado (opcional)';

  @override
  String get customActivityLevelHelperText =>
      'Substitui os rotulos predefinidos quando informado';

  @override
  String get clinicalConditionsLabel =>
      'Condicoes clinicas (separadas por virgula)';

  @override
  String get clinicalConditionsHelperText => 'Exemplos: diabetes, drc, artrite';

  @override
  String get allergiesRestrictionsLabel =>
      'Alergias / restricoes (separadas por virgula)';

  @override
  String get allergiesRestrictionsHelperText =>
      'Exemplos: frango, carne bovina, leite';

  @override
  String get dietaryPreferencesLabel =>
      'Preferencias alimentares (separadas por virgula)';

  @override
  String get dietaryPreferencesHelperText => 'Exemplos: grain_free, low_fat';

  @override
  String get veterinaryNotesOptionalLabel => 'Notas veterinarias (opcional)';

  @override
  String get targetsAlertsSectionTitle => 'Metas e alertas';

  @override
  String get targetsAlertsSectionDescription =>
      'Defina faixa segura de peso e alertas para cada check-in.';

  @override
  String get weightGoalsAlertsTitle => 'Metas e alertas de peso';

  @override
  String get goalMinWeightKgLabel => 'Peso minimo da meta (kg)';

  @override
  String get goalMaxWeightKgLabel => 'Peso maximo da meta (kg)';

  @override
  String get alertDeltaKgPerCheckInLabel => 'Delta de alerta (kg) por check-in';

  @override
  String get alertDeltaPercentPerCheckInLabel =>
      'Delta de alerta (%) por check-in';

  @override
  String get clinicalNotesPreferencesLabel => 'Notas clinicas / preferencias';

  @override
  String get clinicalNotesPreferencesHelperText =>
      'Exemplos: estomago sensivel, seletivo, pos-cirurgia, suporte senior';

  @override
  String catLimitHint(int max) {
    return 'Limite: $max gatos individuais. Grupos sao criados separadamente como unidades operacionais leves.';
  }

  @override
  String get saveChangesAction => 'Salvar alteracoes';

  @override
  String get saveProfileAction => 'Salvar perfil';

  @override
  String get deleteProfileAction => 'Excluir perfil';

  @override
  String get profileFeedsAppDescription =>
      'Os perfis salvos aqui alimentam Home, Plans, Check-in de peso e Dashboard.';

  @override
  String get nothingSelectedYetTitle => 'Nada selecionado ainda';

  @override
  String get dailySelectionRequiredDescription =>
      'Selecione um gato individual ou grupo em Home e salve um plano para desbloquear o Daily.';

  @override
  String get noGroupPlanYetTitle => 'Ainda nao ha plano de grupo';

  @override
  String saveGroupPlanBeforeDailyDescription(String name) {
    return 'Salve um plano alimentar para $name em Plans antes de usar o Daily.';
  }

  @override
  String get groupPlanNotActiveYetTitle =>
      'Plano de grupo ainda nao esta ativo';

  @override
  String groupPlanStartsOnDescription(String name, String date) {
    return 'Este plano de $name comeca em $date.';
  }

  @override
  String get groupSizeMetricTitle => 'TAMANHO DO GRUPO';

  @override
  String get dailyGoalMetricTitleUppercase => 'META DIARIA';

  @override
  String get yesterdayRoutineDuplicatedMessage =>
      'A rotina de ontem foi duplicada para hoje.';

  @override
  String get duplicateYesterdayRoutineAction => 'Duplicar rotina de ontem';

  @override
  String get todaysGroupScheduleTitle => 'Agenda do grupo de hoje';

  @override
  String get noMealPlanYetTitle => 'Ainda nao ha plano alimentar';

  @override
  String savePlanBeforeDailyDescription(String name) {
    return 'Salve um plano alimentar para $name em Plans antes de usar o Daily.';
  }

  @override
  String get planNotActiveYetTitle => 'Plano ainda nao esta ativo';

  @override
  String planStartsOnDescription(String name, String date) {
    return 'O plano de $name comeca em $date.';
  }

  @override
  String get currentWeightMetricTitle => 'PESO ATUAL';

  @override
  String get genericMealTitle => 'Refeicao';

  @override
  String get mealTimeTitle => 'Horario da refeicao';

  @override
  String get unsetLabel => 'Nao definido';

  @override
  String get quantityLabel => 'Quantidade';

  @override
  String get observationsLabel => 'Observacoes';

  @override
  String get dailyObservationsHint =>
      'Motivo do atraso, recusa, apetite, notas praticas etc.';

  @override
  String get saveLogAction => 'Salvar registro';

  @override
  String get dailyGreetingTitle => 'Bom dia!';

  @override
  String dailyGroupReadyDescription(String name) {
    return 'O grupo $name esta pronto para a rotina de hoje';
  }

  @override
  String dailyCatReadyDescription(String name) {
    return '$name esta pronto para as refeicoes de hoje';
  }

  @override
  String get todaysScheduleTitle => 'Agenda de hoje';

  @override
  String loggedQuantityLabel(String quantity, String unit) {
    return 'Registrado: $quantity $unit';
  }

  @override
  String noteWithValueLabel(String note) {
    return 'Nota: $note';
  }

  @override
  String get updateLogAction => 'ATUALIZAR REGISTRO';

  @override
  String get logMealAction => 'REGISTRAR REFEICAO';

  @override
  String get logEventAction => 'REGISTRAR EVENTO';

  @override
  String get recordTodaysWeightProgressDescription =>
      'Registre o progresso do peso de hoje';

  @override
  String get anytimeLabel => 'A qualquer hora';

  @override
  String get noMealsScheduledTitle => 'Nenhuma refeicao programada';

  @override
  String get noMealsScheduledDescription =>
      'Salve um plano em Plans para gerar a agenda de hoje.';

  @override
  String get dailyWaterEntryTitle => 'Agua';

  @override
  String get dailySnacksEntryTitle => 'Petiscos';

  @override
  String get dailySupplementsEntryTitle => 'Suplementos';

  @override
  String get dailyWaterGroupSubtitle => 'Registrar ingestao de agua do grupo';

  @override
  String get dailyWaterCatSubtitle => 'Registrar ingestao de agua do gato';

  @override
  String get dailySnacksGroupSubtitle =>
      'Registrar petiscos oferecidos ao grupo';

  @override
  String get dailySnacksCatSubtitle => 'Registrar petiscos oferecidos hoje';

  @override
  String get dailySupplementsGroupSubtitle => 'Registrar suplementos do grupo';

  @override
  String get dailySupplementsCatSubtitle => 'Registrar suplementos do gato';

  @override
  String productConfirmedFromDatabaseMessage(String name) {
    return '$name confirmado do banco de dados';
  }

  @override
  String get foodGenericLabel => 'Alimento';

  @override
  String get scannerTitle => 'Scanner';

  @override
  String get cameraUnavailableTitle => 'Camera indisponivel';

  @override
  String get cameraUnavailableDescription =>
      'Nao foi possivel iniciar a camera. Na web, use localhost ou https, permita o acesso a camera e mantenha apenas uma aba usando a webcam.';

  @override
  String get webCameraNotRunningHint =>
      'A camera web ainda nao esta ativa. Teste uma aba por vez, permita o acesso a camera e tente o botao de trocar camera.';

  @override
  String get alignBarcodeWithinFrameTitle =>
      'Alinhe o codigo de barras dentro da moldura';

  @override
  String get typeBarcodeToSimulateScanHint =>
      'Digite um codigo de barras para simular a leitura';

  @override
  String get noBarcodeScannedYetTitle => 'Nenhum codigo de barras lido ainda';

  @override
  String noProductFoundForBarcodeTitle(String barcode) {
    return 'Nenhum produto encontrado para $barcode';
  }

  @override
  String get unknownBrandLabel => 'Marca desconhecida';

  @override
  String get kcalPer100gLabel => 'kcal/100g';

  @override
  String get useLiveCameraOrBarcodeDescription =>
      'Use a camera ao vivo ou o campo de codigo de barras acima.';

  @override
  String get createFoodEntryFromBarcodeDescription =>
      'Voce pode criar um novo alimento com este codigo de barras.';

  @override
  String get editManuallyAction => 'Editar manualmente';

  @override
  String get manualEntryAction => 'Entrada manual';

  @override
  String get useProductAction => 'Usar produto';

  @override
  String get confirmProductAction => 'Confirmar produto';

  @override
  String get veterinaryGradeNutritionTagline => 'NUTRICAO DE NIVEL VETERINARIO';

  @override
  String catLimitReached(int max) {
    return 'Limite de gatos atingido. Voce pode criar ate $max gatos.';
  }

  @override
  String get invalidImageFile => 'Arquivo de imagem invalido.';

  @override
  String get languageEnglish => 'Ingles';

  @override
  String get languagePortugueseBrazil => 'Portugues (Brasil)';

  @override
  String get languageTagalog => 'Tagalog';

  @override
  String get dataManagementTitle => 'Gerenciamento de dados';

  @override
  String get backupDataTitle => 'Exportar backup';

  @override
  String get backupDataDescription =>
      'Exporte e compartilhe um backup JSON com todos os dados locais do app.';

  @override
  String get importBackupTitle => 'Importar backup';

  @override
  String get importBackupDescription =>
      'Restaure neste aparelho um backup JSON exportado anteriormente.';

  @override
  String get importBackupConfirmationDescription =>
      'Importar um backup substitui os dados locais atuais deste aparelho. Continue apenas se confiar no arquivo.';

  @override
  String get importAction => 'Importar';

  @override
  String get backupReminderTitle => 'Lembrete de backup';

  @override
  String get backupReminderDescription =>
      'Mostra um aviso nas Configuracoes quando chegar a hora de exportar um novo backup.';

  @override
  String get backupReminderFrequencyTitle => 'Frequencia do lembrete';

  @override
  String backupReminderEveryDays(int days) {
    return 'A cada $days dias';
  }

  @override
  String get backupReminderDueTitle => 'Backup vencido';

  @override
  String backupReminderDueDescription(int days) {
    return 'Exporte um backup novo a cada $days dias para evitar perder os dados locais do navegador.';
  }

  @override
  String get backupNeverExportedLabel => 'Nenhum backup exportado ainda';

  @override
  String lastBackupAtLabel(String date) {
    return 'Ultimo backup: $date';
  }

  @override
  String get backupExportedMessage => 'Backup exportado com sucesso.';

  @override
  String backupImportedMessage(int groups, int cats, int foods, int plans) {
    return 'Backup restaurado: $groups grupos, $cats gatos, $foods alimentos e $plans planos.';
  }

  @override
  String get backupImportFailedMessage =>
      'Nao foi possivel importar este arquivo de backup.';

  @override
  String get generateDemoDataListTileDescription =>
      'Cria um grupo, um gato solo, alimentos, planos, refeicoes e historico de peso.';

  @override
  String get generateStressDataListTileDescription =>
      'Cria um cenario de alto volume para validar muitos gatos e grupos.';

  @override
  String get clearDemoDataListTileDescription =>
      'Remove gatos, grupos, alimentos, planos, refeicoes e historico locais.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'CatDiet Planner';

  @override
  String get settingsTitle => 'Configuracoes';

  @override
  String get languageSectionTitle => 'Idioma';

  @override
  String get appLanguageTitle => 'Idioma do app';

  @override
  String get localizedContentScopeTitle => 'Escopo do conteudo localizado';

  @override
  String get localizedContentScopeDescription =>
      'Notificacoes e textos de relatorio/compartilhamento agora seguem o idioma selecionado.';

  @override
  String get navDaily => 'Dia';

  @override
  String get navHome => 'Inicio';

  @override
  String get navPlans => 'Planos';

  @override
  String get navHistory => 'Historico';

  @override
  String get routeErrorTitle => 'Erro de rota';

  @override
  String get dashboardTitle => 'Painel';

  @override
  String get activeCatTitle => 'Gato ativo';

  @override
  String get editAction => 'Editar';

  @override
  String catAgeYearsOld(int years) {
    return '$years anos';
  }

  @override
  String get scanFoodAction => 'Escanear alimento';

  @override
  String get logWeightAction => 'Registrar peso';

  @override
  String get dailySummaryTitle => 'Resumo diario';

  @override
  String get todayLabel => 'Hoje';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get calorieIntakeLabel => 'CONSUMO CALORICO';

  @override
  String get createPlanToUnlockDailySummary =>
      'Crie um plano para liberar seu resumo diario';

  @override
  String get todayFullyCompleted => 'Hoje foi totalmente concluido';

  @override
  String remainingCaloriesForMeal(int kcal, String meal) {
    return '$kcal kcal restantes para $meal';
  }

  @override
  String get mealTimelineTitle => 'Linha do tempo das refeicoes';

  @override
  String get viewPlanAction => 'Ver plano';

  @override
  String get noTimelineYetTitle => 'Sem linha do tempo ainda';

  @override
  String get noTimelineYetDescription =>
      'Salve um plano alimentar para liberar a linha do tempo das refeicoes.';

  @override
  String mealFallbackTitle(int number) {
    return 'Refeicao $number';
  }

  @override
  String mealMarkedPending(String meal) {
    return '$meal marcada como pendente.';
  }

  @override
  String mealMarkedCompleted(String meal) {
    return '$meal marcada como concluida.';
  }

  @override
  String get planInspectorTitle => 'Inspetor de plano';

  @override
  String get groupPlanInspectorTitle => 'Inspetor de plano do grupo';

  @override
  String get previewTab => 'Preview';

  @override
  String get savedTab => 'Salvo';

  @override
  String get noPreviewYetTitle => 'Ainda sem preview';

  @override
  String get noPreviewYetDescription =>
      'Ajuste alimentos ou parametros do plano para gerar um preview.';

  @override
  String get noCatSelectedTitle => 'Nenhum gato selecionado';

  @override
  String get noCatSelectedDescription =>
      'Selecione um gato para inspecionar seus planos salvos.';

  @override
  String get noSavedPlansYetTitle => 'Ainda sem planos salvos';

  @override
  String get noSavedPlansYetDescription =>
      'Salve um plano para inspeciona-lo aqui.';

  @override
  String get noGroupSelectedTitle => 'Nenhum grupo selecionado';

  @override
  String get noGroupSelectedDescription =>
      'Selecione um grupo para inspecionar seu plano salvo.';

  @override
  String get noSavedGroupPlanTitle => 'Sem plano de grupo salvo';

  @override
  String get noSavedGroupPlanDescription =>
      'Salve um plano de grupo para inspeciona-lo aqui.';

  @override
  String get savedIndividualPlanTitle => 'Plano individual salvo';

  @override
  String get savedGroupPlanTitle => 'Plano de grupo salvo';

  @override
  String get planPreviewTitle => 'Preview do plano';

  @override
  String get groupPlanPreviewTitle => 'Preview do plano do grupo';

  @override
  String get savedCoreTargetsTitle => 'Metas centrais';

  @override
  String get savedCoreTargetsSubtitle =>
      'Valores salvos que estao sendo usados por este plano.';

  @override
  String get savedMealTimelineTitle => 'Linha do tempo das refeicoes';

  @override
  String get savedMealTimelineSubtitle =>
      'Agenda salva e divisao de porcao por refeicao.';

  @override
  String get savedPlanDetailsTitle => 'Detalhes do plano';

  @override
  String get savedPlanDetailsSubtitle =>
      'Contexto operacional, notas e configuracao salva.';

  @override
  String get previewCoreTargetsTitle => 'Metas centrais';

  @override
  String get previewCoreTargetsSubtitle =>
      'Numeros que serao usados quando este rascunho for salvo.';

  @override
  String get previewMealTimelineTitle => 'Linha do tempo das refeicoes';

  @override
  String get previewMealTimelineSubtitle =>
      'Cada refeicao com horario e porcao exata.';

  @override
  String get previewPlanDetailsTitle => 'Detalhes do plano';

  @override
  String get previewPlanDetailsSubtitle =>
      'Contexto que afeta a execucao, mas e facil perder.';

  @override
  String get customPlanLabel => 'Plano personalizado';

  @override
  String startsTag(String date) {
    return 'Comeca $date';
  }

  @override
  String mealsPerDayTag(int count) {
    return '$count refeicoes/dia';
  }

  @override
  String catsCountTag(int count) {
    return '$count gatos';
  }

  @override
  String get activePlanTag => 'Plano ativo';

  @override
  String get metricDailyGoal => 'Meta diaria';

  @override
  String get metricFoodPerDay => 'Alimento por dia';

  @override
  String get metricAveragePerMeal => 'Media por refeicao';

  @override
  String get metricServingUnit => 'Unidade de porcao';

  @override
  String get metricPerCat => 'Por gato';

  @override
  String get metricGroupTotal => 'Total do grupo';

  @override
  String get metricGroupPerDay => 'Grupo por dia';

  @override
  String get metricGroupPerMeal => 'Grupo por refeicao';

  @override
  String get metricSavedAt => 'Salvo em';

  @override
  String get metricOverrides => 'Overrides';

  @override
  String get metricFoods => 'Alimentos';

  @override
  String get metricNotes => 'Notas';

  @override
  String get metricStarts => 'Comeca';

  @override
  String get metricDistribution => 'Distribuicao';

  @override
  String get helperEnergyTarget => 'Meta energetica';

  @override
  String get helperTotalPortion => 'Porcao total';

  @override
  String get helperBaselineSplit => 'Divisao base';

  @override
  String get helperDisplayUnit => 'Unidade exibida';

  @override
  String get helperEnergyTargetPerCat => 'Meta energetica por gato';

  @override
  String get helperCombinedEnergyTarget => 'Meta energetica combinada';

  @override
  String get helperAverageFeedingSlot => 'Media por horario';

  @override
  String get noActiveOverrides => 'Sem overrides ativos';

  @override
  String activeOverridesCount(int count) {
    return '$count overrides ativos';
  }

  @override
  String get noNotesYet => 'Sem notas ainda';

  @override
  String get equalSplitLabel => 'Divisao igual';

  @override
  String unequalSplitLabel(int count) {
    return 'Divisao desigual ($count gatos)';
  }

  @override
  String get activePlanLabelText => 'Plano ativo';

  @override
  String usePlanAction(String date) {
    return 'Usar $date';
  }

  @override
  String get deleteActivePlanAction => 'Excluir plano ativo';

  @override
  String get scheduledFeedingSlotCaption => 'Horario programado de alimentacao';

  @override
  String plusMoreFoods(int count) {
    return '+ $count a mais';
  }

  @override
  String get plansTitle => 'Planos';

  @override
  String get planInspectorTooltip => 'Preview e plano salvo';

  @override
  String get buildPlanTitle => 'Montar plano';

  @override
  String get individualPlanMode => 'Individual';

  @override
  String get groupPlanMode => 'Grupo';

  @override
  String get catProfileLabel => 'Perfil do gato';

  @override
  String get groupLabel => 'Grupo';

  @override
  String groupWithCats(String group, int count) {
    return '$group ($count gatos)';
  }

  @override
  String get targetKcalPerCatPerDayLabel => 'Meta de kcal por gato / dia';

  @override
  String get createGroupAction => 'Criar grupo';

  @override
  String mealsPerDayChip(int count) {
    return '$count refeicoes/dia';
  }

  @override
  String get planStartDateTitle => 'Data de inicio do plano';

  @override
  String startsOnLabel(String date) {
    return 'Comeca em $date';
  }

  @override
  String get portionUnitTitle => 'Unidade da porcao';

  @override
  String get unitLabel => 'Unidade';

  @override
  String get gramsPerUnitLabel => 'Gramas por unidade';

  @override
  String get weekendAlternativeTitle => 'Alternativa para fim de semana';

  @override
  String get weekendAlternativeDescription =>
      'Aplicar um fator diferente de kcal/porcao no sabado e domingo.';

  @override
  String get weekendKcalFactorLabel => 'Fator de kcal no fim de semana (%)';

  @override
  String get byWeekdayTitle => 'Por dia da semana';

  @override
  String get byWeekdayDescription =>
      'Ative dias especificos e defina um fator de kcal/porcao para cada dia.';

  @override
  String get factorPercentLabel => 'Fator %';

  @override
  String get operationalNotesLabel => 'Notas operacionais';

  @override
  String get mealLabelsTitle => 'Nomes das refeicoes';

  @override
  String mealNameLabel(int count) {
    return 'Nome da refeicao $count';
  }

  @override
  String get mealPortionsTitle => 'Porcoes por refeicao';

  @override
  String get mealPortionsDescription =>
      'Defina a porcentagem da porcao diaria servida em cada refeicao. O app normaliza o total para 100%.';

  @override
  String mealShareLabel(String meal) {
    return 'Participacao de $meal (%)';
  }

  @override
  String get mealScheduleTitle => 'Horario das refeicoes';

  @override
  String get mealScheduleDescription =>
      'Escolha o horario de cada refeicao. Daily e Home usarao esta agenda.';

  @override
  String get suggestionsTitle => 'Sugestoes';

  @override
  String get noCatProfilesAvailableTitle => 'Nenhum perfil de gato disponivel';

  @override
  String get noCatProfilesAvailableMessage =>
      'Crie um perfil de gato antes de montar um plano individual.';

  @override
  String get noGroupsAvailableTitle => 'Nenhum grupo disponivel';

  @override
  String get noGroupsAvailableMessage =>
      'Crie um grupo antes de montar um plano compartilhado.';

  @override
  String get availableFoodsTitle => 'Alimentos disponiveis';

  @override
  String get noFoodsAvailableTitle => 'Nenhum alimento disponivel';

  @override
  String get noFoodsAvailableDescription =>
      'Adicione alimentos em Food Database antes de criar um plano.';

  @override
  String get multipleFoodsTitle => 'Multiplos alimentos';

  @override
  String get multipleFoodsDescription =>
      'Permitir selecionar varios alimentos para o plano';

  @override
  String get unknownBrand => 'Marca desconhecida';

  @override
  String get savePlanAction => 'Salvar plano';

  @override
  String get saveGroupPlanAction => 'Salvar plano do grupo';

  @override
  String get savingLabel => 'Salvando...';

  @override
  String get planDeletedMessage => 'Plano excluido.';

  @override
  String planSavedForCatMessage(String name) {
    return 'Plano salvo para $name';
  }

  @override
  String planSavedForGroupMessage(String name) {
    return 'Plano salvo para $name';
  }

  @override
  String get enterValidKcalPerCatMessage =>
      'Digite uma meta de kcal valida por gato.';

  @override
  String get mondayLabel => 'Segunda-feira';

  @override
  String get tuesdayLabel => 'Terca-feira';

  @override
  String get wednesdayLabel => 'Quarta-feira';

  @override
  String get thursdayLabel => 'Quinta-feira';

  @override
  String get fridayLabel => 'Sexta-feira';

  @override
  String get saturdayLabel => 'Sabado';

  @override
  String get sundayLabel => 'Domingo';

  @override
  String dayFallbackLabel(int weekday) {
    return 'Dia $weekday';
  }

  @override
  String get noActiveSuggestionsDescription =>
      'Nenhuma sugestao ativa agora. Continue registrando refeicoes e peso para melhorar as orientacoes.';

  @override
  String get confirmPlanChangeTitle => 'Confirmar mudanca no plano';

  @override
  String applySuggestionAfterReview(String catName) {
    return 'Aplique esta sugestao a $catName somente apos revisao.';
  }

  @override
  String get responsiblePersonLabel => 'Pessoa responsavel';

  @override
  String get typeWhoApprovedHint => 'Digite quem aprovou esta mudanca';

  @override
  String get approvalIdentityRequired =>
      'A identificacao do aprovador e obrigatoria.';

  @override
  String get cancelAction => 'Cancelar';

  @override
  String get confirmAction => 'Confirmar';

  @override
  String get planUpdatedAfterConfirmation =>
      'Plano atualizado apos confirmacao.';

  @override
  String get suggestionRecordedWithoutPlanChanges =>
      'Sugestao registrada sem mudancas no plano.';

  @override
  String suggestionConfidenceLabel(String value) {
    return 'Confianca $value';
  }

  @override
  String get suggestionAcceptedStatus => 'Aceita';

  @override
  String get suggestionDeferredStatus => 'Adiada';

  @override
  String get suggestionIgnoredStatus => 'Ignorada';

  @override
  String get whyThisSuggestionTitle => 'Por que esta sugestao:';

  @override
  String get acceptAction => 'Aceitar';

  @override
  String get deferAction => 'Adiar';

  @override
  String get ignoreAction => 'Ignorar';

  @override
  String get restoreAction => 'Restaurar';

  @override
  String get autoApplyDisabledMessage =>
      'A aplicacao automatica esta desativada. Mudancas no plano sempre exigem confirmacao.';

  @override
  String get suggestionTypeKcal => 'Kcal';

  @override
  String get suggestionTypeSchedule => 'Horario';

  @override
  String get suggestionTypePortions => 'Porcoes';

  @override
  String get suggestionTypePreventiveAlert => 'Alerta preventivo';

  @override
  String get suggestionTypeClinicalWatch => 'Alerta clinico';

  @override
  String get reasonWeightTrendUp =>
      'A tendencia recente de peso esta aumentando';

  @override
  String get reasonWeightTrendDown =>
      'A tendencia recente de peso esta diminuindo';

  @override
  String get reasonOutOfGoalMax => 'O peso esta acima da faixa configurada';

  @override
  String get reasonOutOfGoalMin => 'O peso esta abaixo da faixa configurada';

  @override
  String get reasonApproachingGoalMax =>
      'A tendencia esta se aproximando do limite superior da meta';

  @override
  String get reasonApproachingGoalMin =>
      'A tendencia esta se aproximando do limite inferior da meta';

  @override
  String get reasonAdherenceLow => 'A adesao das refeicoes esta abaixo da meta';

  @override
  String get reasonRefusalFrequent => 'Eventos de recusa sao frequentes';

  @override
  String get reasonDelayedFrequent => 'Refeicoes atrasadas sao frequentes';

  @override
  String get reasonAppetiteReduced =>
      'Reducao de apetite foi registrada recentemente';

  @override
  String get reasonAppetitePoor => 'Baixo apetite foi registrado recentemente';

  @override
  String get reasonVomitFrequent =>
      'Eventos frequentes de vomito foram registrados';

  @override
  String get reasonStoolDiarrhea => 'Eventos de diarreia foram registrados';

  @override
  String get reasonClinicalConditionPresent =>
      'Condicoes clinicas estao configuradas no perfil';

  @override
  String get reasonWeightAlertTriggered =>
      'Alertas de peso foram disparados recentemente';

  @override
  String get reasonLowEvidence =>
      'Dados limitados disponiveis (baixa evidencia)';

  @override
  String dietWeightRangeError(String min, String max) {
    return 'O peso deve estar entre $min e $max kg.';
  }

  @override
  String dietAgeRangeError(String min, String max) {
    return 'A idade deve estar entre $min e $max meses.';
  }

  @override
  String get dietFoodCaloriesPositiveError =>
      'As calorias do alimento devem ser maiores que zero.';

  @override
  String dietMealsRangeError(String min, String max) {
    return 'As refeicoes por dia devem estar entre $min e $max.';
  }

  @override
  String get dietWeightPositiveError => 'O peso deve ser maior que zero.';

  @override
  String get dietMealsPositiveError =>
      'As refeicoes por dia devem ser maiores que zero.';

  @override
  String portionUnknownUnitError(String unit) {
    return 'Unidade de porcao desconhecida \"$unit\".';
  }

  @override
  String portionZeroEquivalentError(String unit) {
    return 'A unidade \"$unit\" tem equivalente em gramas igual a zero.';
  }

  @override
  String get noActivePlanAvailableForCat =>
      'Nenhum plano ativo disponivel para este gato.';

  @override
  String get noSuggestedPlanChangesAvailableToRevert =>
      'Nenhuma mudanca sugerida disponivel para reverter.';

  @override
  String get lastSuggestedChangeReverted =>
      'A ultima mudanca sugerida foi revertida.';

  @override
  String get suggestionDataIncomplete =>
      'Os dados da sugestao estao incompletos.';

  @override
  String get suggestedKcalChangeExceedsSafeBand =>
      'A mudanca sugerida de kcal excede a faixa segura de ajuste.';

  @override
  String get suggestedKcalTargetOutsideSafeRange =>
      'A meta sugerida de kcal esta fora da faixa segura permitida.';

  @override
  String get unableToRecalculatePortionSafely =>
      'Nao foi possivel recalcular a porcao com seguranca.';

  @override
  String get scheduleChangeExceedsSafeShiftLimit =>
      'A mudanca de horario excede o limite seguro de deslocamento.';

  @override
  String get portionRedistributionInvalidForActivePlan =>
      'A redistribuicao de porcao e invalida para o plano ativo.';

  @override
  String get portionShiftExceedsSafeRedistributionLimit =>
      'O deslocamento de porcao excede o limite seguro de redistribuicao.';

  @override
  String get portionRedistributionFailedSafetyValidation =>
      'A redistribuicao de porcao falhou na validacao de seguranca.';

  @override
  String summaryTargetKcalPerDayChange(
    String fromValue,
    String toValue,
    String delta,
  ) {
    return 'Meta kcal/dia: $fromValue -> $toValue ($delta)';
  }

  @override
  String summaryDailyPortionChange(String fromValue, String toValue) {
    return 'Porcao diaria: $fromValue -> $toValue';
  }

  @override
  String summaryMealTimeChange(String meal, String fromValue, String toValue) {
    return '$meal: $fromValue -> $toValue';
  }

  @override
  String summaryMealPortionChange(
    String meal,
    String fromValue,
    String toValue,
  ) {
    return '$meal: $fromValue -> $toValue';
  }

  @override
  String get revertLastSuggestedChangeTitle =>
      'Reverter ultima mudanca sugerida';

  @override
  String get revertLastSuggestedChangeDescription =>
      'Isso restaura o snapshot do plano anterior a ultima mudanca sugerida.';

  @override
  String get typeWhoIsRevertingHint =>
      'Informe quem esta revertendo esta mudanca';

  @override
  String get responsiblePersonRequired =>
      'A identificacao da pessoa responsavel e obrigatoria.';

  @override
  String get revertAction => 'Reverter';

  @override
  String impactRevertedBy(String name) {
    return 'Revertido por $name';
  }

  @override
  String get impactActiveChange => 'Mudanca ativa';

  @override
  String impactBeforeAfterKcal(String beforeValue, String afterValue) {
    return 'Kcal antes/depois: $beforeValue -> $afterValue';
  }

  @override
  String get unknownPersonLabel => 'desconhecido';

  @override
  String get shareMessageTitle => 'Mensagem de compartilhamento';

  @override
  String get shareMessageHint =>
      'Mensagem usada ao compartilhar arquivos de relatorio';

  @override
  String get saveAction => 'Salvar';

  @override
  String get mealReminderTimesTitle => 'Horarios de lembrete de refeicao';

  @override
  String get addTimeAction => 'Adicionar horario';

  @override
  String get saveScheduleAction => 'Salvar agenda';

  @override
  String get generateDemoDataTitle => 'Gerar dados demo';

  @override
  String get generateDemoDataDescription =>
      'Isso vai substituir os dados locais atuais por um cenario pronto para teste com um grupo, um gato individual, alimentos, planos, refeicoes e historico de peso.';

  @override
  String get generateAction => 'Gerar';

  @override
  String demoDataReadyMessage(int groups, int cats, int foods, int schedules) {
    return 'Dados demo prontos: $groups grupo, $cats gato, $foods alimentos, $schedules agendas.';
  }

  @override
  String get clearDemoDataTitle => 'Limpar dados demo';

  @override
  String get clearDemoDataDescription =>
      'Isso vai remover os dados demo locais do app, incluindo gatos, grupos, alimentos, planos, refeicoes e historico.';

  @override
  String get clearAction => 'Limpar';

  @override
  String get localDemoDataClearedMessage => 'Dados demo locais removidos.';

  @override
  String get generateStressDataTitle => 'Gerar dados de teste de estresse';

  @override
  String get generateStressDataDescription =>
      'Isso vai carregar um cenario operacional pesado (ate 10 gatos e 5 grupos) para validar navegacao, listas e rotinas diarias em uso de alto volume.';

  @override
  String stressScenarioReadyMessage(
    int groups,
    int cats,
    int foods,
    int schedules,
  ) {
    return 'Cenario de estresse pronto: $groups grupos, $cats gatos, $foods alimentos, $schedules agendas.';
  }

  @override
  String get customRangeDaysTitle => 'Dias do intervalo personalizado';

  @override
  String customRangeDaysValue(int days) {
    return '$days dias';
  }

  @override
  String get customRangeTitle => 'Intervalo personalizado';

  @override
  String get daysLabel => 'Dias';

  @override
  String get noAcceptedPlanChangesYetTitle =>
      'Nenhuma mudanca de plano aceita ainda';

  @override
  String get noAcceptedPlanChangesYetDescription =>
      'Mudancas aprovadas por sugestao vao registrar quem aceitou, quando e o que mudou.';

  @override
  String get noSuggestionImpactHistoryYetTitle =>
      'Nenhum historico de impacto de sugestoes ainda';

  @override
  String get noSuggestionImpactHistoryYetDescription =>
      'Sugestoes geradas, mudancas aceitas e snapshots de antes/depois serao armazenados aqui.';

  @override
  String get revertLatestSuggestedAdjustmentDescription =>
      'Restaura o snapshot mais recente do plano salvo antes da aplicacao de um ajuste sugerido.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get tryAgainAction => 'Tentar novamente';

  @override
  String get deleteAction => 'Excluir';

  @override
  String get kgUnit => 'kg';

  @override
  String get catsUnit => 'gatos';

  @override
  String get noneOption => 'Nenhum';

  @override
  String get normalOption => 'Normal';

  @override
  String get highOption => 'Alta';

  @override
  String get lowOption => 'Baixa';

  @override
  String get poorOption => 'Ruim';

  @override
  String get reducedOption => 'Reduzido';

  @override
  String get softOption => 'Mole';

  @override
  String get hardOption => 'Duro';

  @override
  String get diarrheaOption => 'Diarreia';

  @override
  String get occasionalOption => 'Ocasional';

  @override
  String get frequentOption => 'Frequente';

  @override
  String get otherOption => 'Outro';

  @override
  String get sedentaryOption => 'Sedentario';

  @override
  String get moderateOption => 'Moderado';

  @override
  String get activeOption => 'Ativo';

  @override
  String get maleOption => 'Macho';

  @override
  String get femaleOption => 'Femea';

  @override
  String get unknownOption => 'Desconhecido';

  @override
  String get maintenanceGoalOption => 'Manutencao';

  @override
  String get weightLossGoalOption => 'Perda de peso';

  @override
  String get weightGainGoalOption => 'Ganho de peso';

  @override
  String get kittenGrowthGoalOption => 'Crescimento do filhote';

  @override
  String get seniorSupportGoalOption => 'Suporte senior';

  @override
  String get recoveryGoalOption => 'Recuperacao';

  @override
  String get postSurgeryGoalOption => 'Pos-cirurgia';

  @override
  String get completedOption => 'Concluido';

  @override
  String get partialOption => 'Parcial';

  @override
  String get delayedOption => 'Atrasado';

  @override
  String get refusedOption => 'Recusado';

  @override
  String get reducedAppetiteOption => 'Apetite reduzido';

  @override
  String get skippedOption => 'Pulado';

  @override
  String get loggedStatus => 'Registrado';

  @override
  String get weightCheckInTitle => 'Check-in de peso';

  @override
  String get noActiveCatTitle => 'Nenhum gato ativo';

  @override
  String get noActiveCatDescription =>
      'Selecione um gato em Home antes de registrar o peso.';

  @override
  String get weightRecordedWithAlertMessage =>
      'Peso registrado com alerta. Revise metas e notas clinicas.';

  @override
  String get weightRecordedMessage => 'Peso registrado.';

  @override
  String get weightNoteSuggestionHighAppetite => 'Muito apetite';

  @override
  String get weightNoteSuggestionEnergetic => 'Energetico';

  @override
  String get weightNoteSuggestionLazyDay => 'Dia preguiçoso';

  @override
  String get weightContextFastingOption => 'Jejum';

  @override
  String get weightContextAfterMealOption => 'Apos refeicao';

  @override
  String get weightContextDifferentScaleOption => 'Balanca diferente';

  @override
  String get noPreviousCheckInLabel => 'Nenhum check-in anterior';

  @override
  String lastCheckInLabel(String date) {
    return 'Ultimo check-in: $date';
  }

  @override
  String recordingNowLabel(String date, String time) {
    return 'Registrando agora: $date as $time';
  }

  @override
  String get lastWeightLabel => 'ULTIMO\nPESO';

  @override
  String get checkInDateTimeTitle => 'Data e hora do check-in';

  @override
  String get currentWeightLabel => 'PESO ATUAL';

  @override
  String get checkInContextTitle => 'Contexto do check-in';

  @override
  String get checkInContextDescription =>
      'Use este contexto para melhorar a interpretacao da tendencia nos relatorios.';

  @override
  String get weightContextLabel => 'Contexto do peso';

  @override
  String get appetiteLabel => 'Apetite';

  @override
  String get stoolLabel => 'Fezes';

  @override
  String get vomitLabel => 'Vomito';

  @override
  String get energyLabel => 'Energia';

  @override
  String get checkInNotesTitle => 'Notas do check-in';

  @override
  String get checkInNotesDescription =>
      'Registre comportamento e acompanhamento clinico desta entrada de peso.';

  @override
  String get weightNotesHint =>
      'Como esta o apetite hoje? Houve mudanca de humor ou energia?';

  @override
  String get clinicalAssessmentStructuredLabel =>
      'Avaliacao clinica (estruturada)';

  @override
  String get clinicalPlanFollowUpLabel => 'Plano clinico / acompanhamento';

  @override
  String get recordWeightAction => 'Registrar peso';

  @override
  String get recordWeightActionUppercase => 'REGISTRAR PESO';

  @override
  String get catProfileTitle => 'Perfil do gato';

  @override
  String get deleteProfileTitle => 'Excluir perfil';

  @override
  String removeProfileMessage(String name) {
    return 'Remover $name do app?';
  }

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get createNewCatProfileTitle => 'Criar um novo perfil de gato';

  @override
  String get catProfileIntroDescription =>
      'Dados pessoais, contexto clinico e metas alimentares em um so lugar.';

  @override
  String get uploadPhotoAction => 'Enviar foto';

  @override
  String get coreProfileSectionTitle => 'Perfil base';

  @override
  String get coreProfileSectionDescription =>
      'Identidade e dados metabolicos usados em todo o app.';

  @override
  String get nameLabel => 'Nome';

  @override
  String get enterCatNameError => 'Informe o nome do gato';

  @override
  String get weightKgLabel => 'Peso (kg)';

  @override
  String get invalidWeightError => 'Peso invalido';

  @override
  String get ageYearsLabel => 'Idade (anos)';

  @override
  String get invalidAgeError => 'Idade invalida';

  @override
  String get neuteredSpayedTitle => 'Castrado / esterilizado';

  @override
  String get neuteredSpayedDescription => 'Afeta a necessidade calorica';

  @override
  String get activityLevelLabel => 'Nivel de atividade';

  @override
  String get goalLabel => 'Objetivo';

  @override
  String get preferredMealsPerDayLabel => 'Refeicoes preferidas por dia';

  @override
  String get manualTargetKcalPerDayOptionalLabel =>
      'Meta manual de kcal/dia (opcional)';

  @override
  String get manualTargetKcalHelperText =>
      'Deixe vazio para manter o calculo automatico';

  @override
  String get invalidKcalTargetError => 'Meta de kcal invalida';

  @override
  String get clinicalContextSectionTitle => 'Contexto clinico';

  @override
  String get clinicalContextSectionDescription =>
      'Campos opcionais que refinam recomendacoes e acompanhamento clinico.';

  @override
  String get idealWeightOptionalLabel => 'Peso ideal (kg) (opcional)';

  @override
  String get idealWeightHelperText =>
      'Opcional: usado para refinar sugestoes de kcal';

  @override
  String get invalidIdealWeightError => 'Peso ideal invalido';

  @override
  String get bodyConditionScoreLabel => 'Escore de condicao corporal (1-9)';

  @override
  String get sexLabel => 'Sexo';

  @override
  String get breedOptionalLabel => 'Raca (opcional)';

  @override
  String get dateOfBirthOptionalLabel => 'Data de nascimento (opcional)';

  @override
  String get customActivityLevelOptionalLabel =>
      'Nivel de atividade customizado (opcional)';

  @override
  String get customActivityLevelHelperText =>
      'Substitui os rotulos predefinidos quando informado';

  @override
  String get clinicalConditionsLabel =>
      'Condicoes clinicas (separadas por virgula)';

  @override
  String get clinicalConditionsHelperText => 'Exemplos: diabetes, drc, artrite';

  @override
  String get allergiesRestrictionsLabel =>
      'Alergias / restricoes (separadas por virgula)';

  @override
  String get allergiesRestrictionsHelperText =>
      'Exemplos: frango, carne bovina, leite';

  @override
  String get dietaryPreferencesLabel =>
      'Preferencias alimentares (separadas por virgula)';

  @override
  String get dietaryPreferencesHelperText => 'Exemplos: grain_free, low_fat';

  @override
  String get veterinaryNotesOptionalLabel => 'Notas veterinarias (opcional)';

  @override
  String get targetsAlertsSectionTitle => 'Metas e alertas';

  @override
  String get targetsAlertsSectionDescription =>
      'Defina faixa segura de peso e alertas para cada check-in.';

  @override
  String get weightGoalsAlertsTitle => 'Metas e alertas de peso';

  @override
  String get goalMinWeightKgLabel => 'Peso minimo da meta (kg)';

  @override
  String get goalMaxWeightKgLabel => 'Peso maximo da meta (kg)';

  @override
  String get alertDeltaKgPerCheckInLabel => 'Delta de alerta (kg) por check-in';

  @override
  String get alertDeltaPercentPerCheckInLabel =>
      'Delta de alerta (%) por check-in';

  @override
  String get clinicalNotesPreferencesLabel => 'Notas clinicas / preferencias';

  @override
  String get clinicalNotesPreferencesHelperText =>
      'Exemplos: estomago sensivel, seletivo, pos-cirurgia, suporte senior';

  @override
  String catLimitHint(int max) {
    return 'Limite: $max gatos individuais. Grupos sao criados separadamente como unidades operacionais leves.';
  }

  @override
  String get saveChangesAction => 'Salvar alteracoes';

  @override
  String get saveProfileAction => 'Salvar perfil';

  @override
  String get deleteProfileAction => 'Excluir perfil';

  @override
  String get profileFeedsAppDescription =>
      'Os perfis salvos aqui alimentam Home, Plans, Check-in de peso e Dashboard.';

  @override
  String get nothingSelectedYetTitle => 'Nada selecionado ainda';

  @override
  String get dailySelectionRequiredDescription =>
      'Selecione um gato individual ou grupo em Home e salve um plano para desbloquear o Daily.';

  @override
  String get noGroupPlanYetTitle => 'Ainda nao ha plano de grupo';

  @override
  String saveGroupPlanBeforeDailyDescription(String name) {
    return 'Salve um plano alimentar para $name em Plans antes de usar o Daily.';
  }

  @override
  String get groupPlanNotActiveYetTitle =>
      'Plano de grupo ainda nao esta ativo';

  @override
  String groupPlanStartsOnDescription(String name, String date) {
    return 'Este plano de $name comeca em $date.';
  }

  @override
  String get groupSizeMetricTitle => 'TAMANHO DO GRUPO';

  @override
  String get dailyGoalMetricTitleUppercase => 'META DIARIA';

  @override
  String get yesterdayRoutineDuplicatedMessage =>
      'A rotina de ontem foi duplicada para hoje.';

  @override
  String get duplicateYesterdayRoutineAction => 'Duplicar rotina de ontem';

  @override
  String get todaysGroupScheduleTitle => 'Agenda do grupo de hoje';

  @override
  String get noMealPlanYetTitle => 'Ainda nao ha plano alimentar';

  @override
  String savePlanBeforeDailyDescription(String name) {
    return 'Salve um plano alimentar para $name em Plans antes de usar o Daily.';
  }

  @override
  String get planNotActiveYetTitle => 'Plano ainda nao esta ativo';

  @override
  String planStartsOnDescription(String name, String date) {
    return 'O plano de $name comeca em $date.';
  }

  @override
  String get currentWeightMetricTitle => 'PESO ATUAL';

  @override
  String get genericMealTitle => 'Refeicao';

  @override
  String get mealTimeTitle => 'Horario da refeicao';

  @override
  String get unsetLabel => 'Nao definido';

  @override
  String get quantityLabel => 'Quantidade';

  @override
  String get observationsLabel => 'Observacoes';

  @override
  String get dailyObservationsHint =>
      'Motivo do atraso, recusa, apetite, notas praticas etc.';

  @override
  String get saveLogAction => 'Salvar registro';

  @override
  String get dailyGreetingTitle => 'Bom dia!';

  @override
  String dailyGroupReadyDescription(String name) {
    return 'O grupo $name esta pronto para a rotina de hoje';
  }

  @override
  String dailyCatReadyDescription(String name) {
    return '$name esta pronto para as refeicoes de hoje';
  }

  @override
  String get todaysScheduleTitle => 'Agenda de hoje';

  @override
  String loggedQuantityLabel(String quantity, String unit) {
    return 'Registrado: $quantity $unit';
  }

  @override
  String noteWithValueLabel(String note) {
    return 'Nota: $note';
  }

  @override
  String get updateLogAction => 'ATUALIZAR REGISTRO';

  @override
  String get logMealAction => 'REGISTRAR REFEICAO';

  @override
  String get logEventAction => 'REGISTRAR EVENTO';

  @override
  String get recordTodaysWeightProgressDescription =>
      'Registre o progresso do peso de hoje';

  @override
  String get anytimeLabel => 'A qualquer hora';

  @override
  String get noMealsScheduledTitle => 'Nenhuma refeicao programada';

  @override
  String get noMealsScheduledDescription =>
      'Salve um plano em Plans para gerar a agenda de hoje.';

  @override
  String get dailyWaterEntryTitle => 'Agua';

  @override
  String get dailySnacksEntryTitle => 'Petiscos';

  @override
  String get dailySupplementsEntryTitle => 'Suplementos';

  @override
  String get dailyWaterGroupSubtitle => 'Registrar ingestao de agua do grupo';

  @override
  String get dailyWaterCatSubtitle => 'Registrar ingestao de agua do gato';

  @override
  String get dailySnacksGroupSubtitle =>
      'Registrar petiscos oferecidos ao grupo';

  @override
  String get dailySnacksCatSubtitle => 'Registrar petiscos oferecidos hoje';

  @override
  String get dailySupplementsGroupSubtitle => 'Registrar suplementos do grupo';

  @override
  String get dailySupplementsCatSubtitle => 'Registrar suplementos do gato';

  @override
  String productConfirmedFromDatabaseMessage(String name) {
    return '$name confirmado do banco de dados';
  }

  @override
  String get foodGenericLabel => 'Alimento';

  @override
  String get scannerTitle => 'Scanner';

  @override
  String get cameraUnavailableTitle => 'Camera indisponivel';

  @override
  String get cameraUnavailableDescription =>
      'Nao foi possivel iniciar a camera. Na web, use localhost ou https, permita o acesso a camera e mantenha apenas uma aba usando a webcam.';

  @override
  String get webCameraNotRunningHint =>
      'A camera web ainda nao esta ativa. Teste uma aba por vez, permita o acesso a camera e tente o botao de trocar camera.';

  @override
  String get alignBarcodeWithinFrameTitle =>
      'Alinhe o codigo de barras dentro da moldura';

  @override
  String get typeBarcodeToSimulateScanHint =>
      'Digite um codigo de barras para simular a leitura';

  @override
  String get noBarcodeScannedYetTitle => 'Nenhum codigo de barras lido ainda';

  @override
  String noProductFoundForBarcodeTitle(String barcode) {
    return 'Nenhum produto encontrado para $barcode';
  }

  @override
  String get unknownBrandLabel => 'Marca desconhecida';

  @override
  String get kcalPer100gLabel => 'kcal/100g';

  @override
  String get useLiveCameraOrBarcodeDescription =>
      'Use a camera ao vivo ou o campo de codigo de barras acima.';

  @override
  String get createFoodEntryFromBarcodeDescription =>
      'Voce pode criar um novo alimento com este codigo de barras.';

  @override
  String get editManuallyAction => 'Editar manualmente';

  @override
  String get manualEntryAction => 'Entrada manual';

  @override
  String get useProductAction => 'Usar produto';

  @override
  String get confirmProductAction => 'Confirmar produto';

  @override
  String get veterinaryGradeNutritionTagline => 'NUTRICAO DE NIVEL VETERINARIO';

  @override
  String catLimitReached(int max) {
    return 'Limite de gatos atingido. Voce pode criar ate $max gatos.';
  }

  @override
  String get invalidImageFile => 'Arquivo de imagem invalido.';

  @override
  String get languageEnglish => 'Ingles';

  @override
  String get languagePortugueseBrazil => 'Portugues (Brasil)';

  @override
  String get languageTagalog => 'Tagalog';

  @override
  String get dataManagementTitle => 'Gerenciamento de dados';

  @override
  String get backupDataTitle => 'Exportar backup';

  @override
  String get backupDataDescription =>
      'Exporte e compartilhe um backup JSON com todos os dados locais do app.';

  @override
  String get importBackupTitle => 'Importar backup';

  @override
  String get importBackupDescription =>
      'Restaure neste aparelho um backup JSON exportado anteriormente.';

  @override
  String get importBackupConfirmationDescription =>
      'Importar um backup substitui os dados locais atuais deste aparelho. Continue apenas se confiar no arquivo.';

  @override
  String get importAction => 'Importar';

  @override
  String get backupReminderTitle => 'Lembrete de backup';

  @override
  String get backupReminderDescription =>
      'Mostra um aviso nas Configuracoes quando chegar a hora de exportar um novo backup.';

  @override
  String get backupReminderFrequencyTitle => 'Frequencia do lembrete';

  @override
  String backupReminderEveryDays(int days) {
    return 'A cada $days dias';
  }

  @override
  String get backupReminderDueTitle => 'Backup vencido';

  @override
  String backupReminderDueDescription(int days) {
    return 'Exporte um backup novo a cada $days dias para evitar perder os dados locais do navegador.';
  }

  @override
  String get backupNeverExportedLabel => 'Nenhum backup exportado ainda';

  @override
  String lastBackupAtLabel(String date) {
    return 'Ultimo backup: $date';
  }

  @override
  String get backupExportedMessage => 'Backup exportado com sucesso.';

  @override
  String backupImportedMessage(int groups, int cats, int foods, int plans) {
    return 'Backup restaurado: $groups grupos, $cats gatos, $foods alimentos e $plans planos.';
  }

  @override
  String get backupImportFailedMessage =>
      'Nao foi possivel importar este arquivo de backup.';

  @override
  String get generateDemoDataListTileDescription =>
      'Cria um grupo, um gato solo, alimentos, planos, refeicoes e historico de peso.';

  @override
  String get generateStressDataListTileDescription =>
      'Cria um cenario de alto volume para validar muitos gatos e grupos.';

  @override
  String get clearDemoDataListTileDescription =>
      'Remove gatos, grupos, alimentos, planos, refeicoes e historico locais.';
}
