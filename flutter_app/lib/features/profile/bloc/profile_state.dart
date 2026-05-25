import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isEditing;
  final bool isLoading;
  final String? errorMessage;

  final String name;
  final String email;
  final String phone;
  final String location;
  final String landSize;
  final String joinedAtText;

  final int totalLahan;
  final double totalLuas;

  const ProfileState({
    required this.isEditing,
    required this.isLoading,
    required this.errorMessage,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.landSize,
    required this.joinedAtText,
    required this.totalLahan,
    required this.totalLuas,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      isEditing: false,
      isLoading: true,
      errorMessage: null,
      name: '-',
      email: '-',
      phone: '-',
      location: '-',
      landSize: '-',
      joinedAtText: 'Bergabung sejak -',
      totalLahan: 0,
      totalLuas: 0,
    );
  }

  ProfileState copyWith({
    bool? isEditing,
    bool? isLoading,
    String? errorMessage,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? landSize,
    String? joinedAtText,
    int? totalLahan,
    double? totalLuas,
  }) {
    return ProfileState(
      isEditing: isEditing ?? this.isEditing,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      landSize: landSize ?? this.landSize,
      joinedAtText: joinedAtText ?? this.joinedAtText,
      totalLahan: totalLahan ?? this.totalLahan,
      totalLuas: totalLuas ?? this.totalLuas,
    );
  }

  @override
  List<Object?> get props => [
        isEditing,
        isLoading,
        errorMessage,
        name,
        email,
        phone,
        location,
        landSize,
        joinedAtText,
        totalLahan,
        totalLuas,
      ];
}