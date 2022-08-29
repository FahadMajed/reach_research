import 'package:reach_research/data/repositories/enrollments_repository.dart';
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
