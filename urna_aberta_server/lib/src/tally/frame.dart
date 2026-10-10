import '../generated/protocol.dart';
import 'aggregator.dart' as tally;

/// The national file and the independent sum of [states] at [at]. Without
/// a national file yet, its side shows zero and `br` is listed missing.
TallyFrame buildTallyFrame({
  required DateTime at,
  required DataOrigin origin,
  required tally.ScopeResult? national,
  required List<tally.ScopeResult> states,
}) {
  final sum = tally.sumOfStates(states);
  final numbers = {...?national?.votes.keys, ...sum.votes.keys};
  final names = {
    for (final s in [...states, ?national]) ...s.candidates,
  };
  return TallyFrame(
    at: at,
    origin: origin,
    nationalPct: national?.sectionsTotalizedPct ?? 0,
    statesPct: sum.sectionsTotalizedPct,
    missingScopes: [if (national == null) 'br', ...sum.missing],
    candidates: [
      for (final n in numbers)
        CandidateVotes(
          candidateNumber: n,
          national: national?.votes[n] ?? 0,
          states: sum.votes[n] ?? 0,
          ballotName: names[n]?.ballotName,
          party: names[n]?.party,
        ),
    ]..sort((a, b) => b.states.compareTo(a.states)),
    ufs: [
      for (final s in states)
        UfProgress(
          scopeCode: s.scope,
          sectionsTotal: s.sectionsTotal,
          sectionsTotalized: s.sectionsTotalized,
        ),
    ]..sort((a, b) => a.scopeCode.compareTo(b.scopeCode)),
  );
}
