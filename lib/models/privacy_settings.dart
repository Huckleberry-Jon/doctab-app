class PrivacySettings {
  const PrivacySettings({
    this.aiAccessEnabled = false,
    this.allowNotes = false,
    this.allowReminders = false,
    this.allowMemory = false,
  });

  final bool aiAccessEnabled;
  final bool allowNotes;
  final bool allowReminders;
  final bool allowMemory;

  PrivacySettings copyWith({
    bool? aiAccessEnabled,
    bool? allowNotes,
    bool? allowReminders,
    bool? allowMemory,
  }) {
    return PrivacySettings(
      aiAccessEnabled: aiAccessEnabled ?? this.aiAccessEnabled,
      allowNotes: allowNotes ?? this.allowNotes,
      allowReminders: allowReminders ?? this.allowReminders,
      allowMemory: allowMemory ?? this.allowMemory,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'aiAccessEnabled': aiAccessEnabled,
        'allowNotes': allowNotes,
        'allowReminders': allowReminders,
        'allowMemory': allowMemory,
      };

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      aiAccessEnabled: json['aiAccessEnabled'] as bool? ?? false,
      allowNotes: json['allowNotes'] as bool? ?? false,
      allowReminders: json['allowReminders'] as bool? ?? false,
      allowMemory: json['allowMemory'] as bool? ?? false,
    );
  }
}