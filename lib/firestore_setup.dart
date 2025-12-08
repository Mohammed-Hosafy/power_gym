import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FirestoreSetup {
  static Future<void> createUser(
    String userId, {
    required String username,
    required String name,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
    required String goal,
    required String password,
    required String profileImage,
  }) async {
    await firestore.collection('users').doc(userId).set({
      'username': username,
      'name': name,
      'date_of_birth': Timestamp.fromDate(dateOfBirth),
      'height': height,
      'weight': weight,
      'goal': goal,
      'password': password,
      'profile_image': profileImage,
    });
  }

  static Future<void> addSchedule(
    String userId,
    String scheduleId,
    String workoutId,
    String dayOfWeek,
  ) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('schedule')
        .doc(scheduleId)
        .set({'workoutId': workoutId, 'dayOfWeek': dayOfWeek});
  }

  static Future<void> addCardio(
    String userId,
    String cardioId,
    int duration,
  ) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('cardio')
        .doc(cardioId)
        .set({'duration': duration});
  }

  static Future<void> addDiet(
    String userId,
    String dietId,
    int dailyCalories,
  ) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('diet')
        .doc(dietId)
        .set({'dailyCalories': dailyCalories});
  }

  static Future<void> createWorkout(
    String workoutId,
    String type,
    String name,
    String description,
    String videoUrl,
  ) async {
    await firestore.collection('workouts').doc(workoutId).set({
      'type': type,
      'name': name,
      'description': description,
      'videoUrl': videoUrl,
    });
  }

  static Future<void> createFullUserExample() async {
    String userId = 'user1';

    await createUser(
      userId,
      username: 'user123',
      name: 'Mohamed Hosafy',
      dateOfBirth: DateTime(2004, 7, 5),
      height: 175,
      weight: 70,
      goal: 'muscle',
      password: '123456',
      profileImage: 'https://example.com/profile.jpg',
    );

    await addSchedule(userId, 'schedule1', 'workout1', 'Monday');
    await addCardio(userId, 'cardio1', 30);
    await addDiet(userId, 'diet1', 2500);
  }

  static Future<void> createWorkoutExample() async {
    await createWorkout(
      'workout1',
      'strength',
      'Push Ups',
      'Do 3 sets of push ups',
      'https://video.url',
    );
  }
}
