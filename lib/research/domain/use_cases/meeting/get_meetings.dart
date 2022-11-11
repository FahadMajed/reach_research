// ignore_for_file: avoid_renaming_method_parameters

import 'package:reach_core/core/core.dart';
import 'package:reach_research/research/research.dart';

class GetMeetings extends UseCase<List<Meeting>, String> {
  final ResearchsRepository repository;
  GetMeetings(this.repository);
  @override
  Future<List<Meeting>> call(String researchId) async =>
      await repository.getMeetings(researchId);
}

final getMeetingsPvdr = Provider<GetMeetings>((ref) => GetMeetings(
      ref.read(researchsRepoPvdr),
    ));
