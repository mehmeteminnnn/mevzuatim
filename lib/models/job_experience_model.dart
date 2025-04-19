class JobExperience {
  final int id;
  final String jobTitle;
  final String companyName;
  final String employmentType;
  final String startDate;
  final String? endDate;
  final String city;
  final String workMode;
  final int userId;

  JobExperience({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.employmentType,
    required this.startDate,
    this.endDate,
    required this.city,
    required this.workMode,
    required this.userId,
  });

  factory JobExperience.fromJson(Map<String, dynamic> json) {
    return JobExperience(
      id: json['id'],
      jobTitle: json['job_title'],
      companyName: json['company_name'],
      employmentType: json['employment_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      city: json['city'],
      workMode: json['work_mode'],
      userId: json['user_id'],
    );
  }
}

class UserProfile {
  final String username;
  final String mail;
  final String id;
  final String yetki;
  final String aboutMe;
  final String expertise;
  final String profileImage;
  final List<JobExperience> jobExperiences;

  UserProfile({
    required this.username,
    required this.mail,
    required this.id,
    required this.yetki,
    required this.aboutMe,
    required this.expertise,
    required this.profileImage,
    required this.jobExperiences,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      mail: json['mail'],
      id: json['id'],
      yetki: json['yetki'],
      aboutMe: json['about_me'],
      expertise: json['expertise'],
      profileImage: json['profile_image'],
      jobExperiences: (json['job_experiences'] as List)
          .map((e) => JobExperience.fromJson(e))
          .toList(),
    );
  }

  // CopyWith metodu
  UserProfile copyWith({
    String? username,
    String? mail,
    String? id,
    String? yetki,
    String? aboutMe,
    String? expertise,
    String? profileImage,
    List<JobExperience>? jobExperiences,
  }) {
    return UserProfile(
      username: username ?? this.username,
      mail: mail ?? this.mail,
      id: id ?? this.id,
      yetki: yetki ?? this.yetki,
      aboutMe: aboutMe ?? this.aboutMe,
      expertise: expertise ?? this.expertise,
      profileImage: profileImage ?? this.profileImage,
      jobExperiences: jobExperiences ?? this.jobExperiences,
    );
  }
}

