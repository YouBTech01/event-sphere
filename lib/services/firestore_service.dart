import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _eventsRef => _firestore.collection('events');
  CollectionReference get _usersRef => _firestore.collection('users');

  /// Stream of active upcoming events
  Stream<List<EventModel>> getEventsStream() {
    return _eventsRef
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final events = snapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
      // Sort in-memory to ensure correct chronology without requiring complex composite index
      events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return events;
    });
  }

  /// Stream to check if a specific user is registered for an event
  Stream<bool> isUserRegisteredStream({
    required String eventId,
    required String userId,
  }) {
    if (userId.isEmpty) return Stream.value(false);
    return _eventsRef
        .doc(eventId)
        .collection('registrations')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  /// One-time check if user is already registered for an event
  Future<bool> isUserRegistered({
    required String eventId,
    required String userId,
  }) async {
    final doc = await _eventsRef
        .doc(eventId)
        .collection('registrations')
        .doc(userId)
        .get();
    return doc.exists;
  }

  /// Register user for an event and update joinedEventsCount
  Future<void> registerForEvent({
    required String eventId,
    required String userId,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final registrationRef =
        _eventsRef.doc(eventId).collection('registrations').doc(userId);
    final userRef = _usersRef.doc(userId);

    // 1. Check if user is already registered for this event
    final existingReg = await registrationRef.get();
    if (existingReg.exists) {
      throw Exception('You have already joined this event.');
    }

    // 2. Perform atomic batch write for registration and user counter
    final batch = _firestore.batch();

    // Save registration in subcollection: events/{eventId}/registrations/{userId}
    batch.set(registrationRef, {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'joinedAt': FieldValue.serverTimestamp(),
    });

    // Update user document joinedEventsCount
    batch.set(
      userRef,
      {
        'fullName': fullName,
        'email': email,
        'joinedEventsCount': FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  /// Stream of user document
  Stream<UserModel?> getUserStream(String userId) {
    if (userId.isEmpty) return Stream.value(null);
    return _usersRef.doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserModel.fromFirestore(snapshot);
    });
  }

  /// Update user's theme mode in Firestore
  Future<void> updateUserTheme(String userId, String themeMode) async {
    await _usersRef.doc(userId).set({
      'themeMode': themeMode,
    }, SetOptions(merge: true));
  }

  /// Seed initial sample events if Firestore is empty
  Future<void> seedInitialEventsIfEmpty() async {
    final snapshot = await _eventsRef.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final now = DateTime.now();
    final sampleEvents = [
      {
        'title': 'Developer Meetup',
        'description':
            'A community developer event connecting coders, designers, and tech enthusiasts for Flutter and AI innovation.',
        'dateTime': Timestamp.fromDate(now.add(const Duration(days: 7, hours: 3))),
        'venue': 'Jabalpur Tech Park, Jabalpur',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Flutter & Firebase Masterclass',
        'description':
            'Hands-on workshop on Firebase integration, Cloud Functions, and reactive state management best practices.',
        'dateTime': Timestamp.fromDate(now.add(const Duration(days: 14, hours: 5))),
        'venue': 'Auditorium B, Jabalpur Engineering College',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Design Systems & UX Conference',
        'description':
            'Explore modern UI design principles, responsive systems, and accessible interaction patterns.',
        'dateTime': Timestamp.fromDate(now.add(const Duration(days: 21, hours: 2))),
        'venue': 'Innovation Hub, City Center, Jabalpur',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final event in sampleEvents) {
      await _eventsRef.add(event);
    }
  }
}
