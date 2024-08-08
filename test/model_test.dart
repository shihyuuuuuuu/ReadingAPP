import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reading_app/data/models/user.dart';
import 'mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUserRepository mockUserRepo;

  setUpAll(() {
    mockUserRepo = MockUserRepository();
  });

  group('Firestore Model Test', () {
    test('Add user to Firestore', () async {
      final newUser = User.fromMap({
        'id': 'test_id',
        'name': 'Jack',
        'avatarUrl': 'http://example.com/avatar1.jpg',
      }, 'test_id');

      when(mockUserRepo.addUser(any))
          .thenAnswer((_) async {});
      when(mockUserRepo.getUser(any))
          .thenAnswer((_) async => newUser);

      await mockUserRepo.addUser(newUser);
      User? user = await mockUserRepo.getUser('Jack');

      expect(user != null, true);
      expect(user!.name, newUser.name);
      expect(user.avatarUrl, newUser.avatarUrl);
    });
  });
}
