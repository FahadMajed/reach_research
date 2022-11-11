import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GetEnrollments extends UseCase<List<Enrollment>, String> {
  final EnrollmentsRepository repository;

  GetEnrollments(this.repository);

  @override
  Future<List<Enrollment>> call(researchId) async =>
      await repository.getEnrollments(researchId);
}

final getEnrollmentsPvdr = Provider<GetEnrollments>((ref) => GetEnrollments(
      ref.read(enrollmentsRepoPvdr),
    ));
