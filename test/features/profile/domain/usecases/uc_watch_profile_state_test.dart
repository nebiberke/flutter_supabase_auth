import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_watch_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock sınıfları
class MockProfileRepository extends Mock implements ProfileRepository {}

// Fake sınıfları
class FakeProfileEntity extends Fake implements ProfileEntity {}

void main() {
  late UCWatchProfileState useCase;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeProfileEntity());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UCWatchProfileState(repository: mockRepository);
  });

  group('UCWatchProfileState', () {
    const tUserId = 'test-user-id';
    const tProfile = ProfileEntity(
      id: tUserId,
      email: 'test@example.com',
      fullName: 'Test User',
      username: 'testuser',
      avatarUrl: 'https://example.com/avatar.jpg',
    );

    const tParams = WatchProfileStateParams(userId: tUserId);

    test(
      "repository'den başarılı stream alınca Right(ProfileEntity) stream'i döndürmeli",
      () async {
        // Arrange
        final profileStream = Stream.value(
          const Right<Failure, ProfileEntity?>(tProfile),
        );
        when(
          () => mockRepository.watchProfileState(any()),
        ).thenAnswer((_) => profileStream);

        // Act
        final resultStream = useCase(tParams);

        // Assert
        await expectLater(
          resultStream,
          emits(const Right<Failure, ProfileEntity?>(tProfile)),
        );
        verify(() => mockRepository.watchProfileState(tUserId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      "repository hata stream'i döndürünce Left(Failure) stream'i döndürmeli",
      () async {
        // Arrange
        const tFailure = DatabaseFailure();
        final failureStream = Stream.value(
          const Left<Failure, ProfileEntity?>(tFailure),
        );
        when(
          () => mockRepository.watchProfileState(any()),
        ).thenAnswer((_) => failureStream);

        // Act
        final resultStream = useCase(tParams);

        // Assert
        await expectLater(
          resultStream,
          emits(const Left<DatabaseFailure, ProfileEntity?>(tFailure)),
        );
        verify(() => mockRepository.watchProfileState(tUserId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test("null profile ile Right(null) stream'i döndürmeli", () async {
      // Arrange
      final nullProfileStream = Stream.value(
        const Right<Failure, ProfileEntity?>(null),
      );
      when(
        () => mockRepository.watchProfileState(any()),
      ).thenAnswer((_) => nullProfileStream);

      // Act
      final resultStream = useCase(tParams);

      // Assert
      await expectLater(
        resultStream,
        emits(const Right<Failure, ProfileEntity?>(null)),
      );
      verify(() => mockRepository.watchProfileState(tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("doğru userId parametresiyle repository'yi çağırmalı", () async {
      // Arrange
      final profileStream = Stream.value(
        const Right<Failure, ProfileEntity?>(tProfile),
      );
      when(
        () => mockRepository.watchProfileState(any()),
      ).thenAnswer((_) => profileStream);

      // Act
      final resultStream = useCase(tParams);

      // Stream'i consume etmek için listen et
      await resultStream.take(1).toList();

      // Assert
      verify(() => mockRepository.watchProfileState(tUserId)).called(1);
    });

    test("birden çok güncelleme stream'ini handle etmeli", () async {
      // Arrange
      const updatedProfile = ProfileEntity(
        id: tUserId,
        email: 'updated@example.com',
        fullName: 'Updated User',
        username: 'updateduser',
        avatarUrl: 'https://example.com/new-avatar.jpg',
      );

      final multipleUpdatesStream = Stream.fromIterable([
        const Right<Failure, ProfileEntity?>(tProfile),
        const Right<Failure, ProfileEntity?>(updatedProfile),
        const Right<Failure, ProfileEntity?>(null),
      ]);

      when(
        () => mockRepository.watchProfileState(any()),
      ).thenAnswer((_) => multipleUpdatesStream);

      // Act
      final resultStream = useCase(tParams);

      // Assert
      await expectLater(
        resultStream,
        emitsInOrder([
          const Right<Failure, ProfileEntity?>(tProfile),
          const Right<Failure, ProfileEntity?>(updatedProfile),
          const Right<Failure, ProfileEntity?>(null),
        ]),
      );
      verify(() => mockRepository.watchProfileState(tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('WatchProfileStateParams eşitlik karşılaştırmasını doğru yapmalı', () {
      // Arrange
      const params1 = WatchProfileStateParams(userId: 'user1');
      const params2 = WatchProfileStateParams(userId: 'user1');
      const params3 = WatchProfileStateParams(userId: 'user2');

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1.props, equals(['user1']));
    });
  });
}
