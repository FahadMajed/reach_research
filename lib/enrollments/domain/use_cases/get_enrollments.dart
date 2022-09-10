import 'package:reach_core/core/core.dart';

import 'package:reach_research/research.dart';

class GetEnrollments extends UseCase<List<Enrollment>, GetEnrollmentsParams> {
  final EnrollmentsRepository repository;

  GetEnrollments(this.repository);

  @override
  Future<List<Enrollment>> call(GetEnrollmentsParams params) async =>
      await repository.getEnrollments(params.researchId);
}

class GetEnrollmentsParams {
  final String researchId;

  GetEnrollmentsParams({
    required this.researchId,
  });
}

final getEnrollmentsPvdr = Provider<GetEnrollments>((ref) => GetEnrollments(
      ref.read(enrollmentsRepoPvdr),
    ));
