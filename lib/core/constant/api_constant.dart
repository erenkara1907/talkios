String baseUrl = "https://talkios.rondigital.ai/api/v3";

class ApiConstant {
  static ApiConstant? _instance;
  static ApiConstant get instance {
    _instance ??= ApiConstant._init();
    return _instance!;
  }

  ApiConstant._init();

  // Auth
  String registerUrl = "$baseUrl/auth/register";
  String loginUrl = "$baseUrl/auth/login";
  String forgotPassword = "$baseUrl/auth/forgot-password";
  String verifyResetToken = "$baseUrl/auth/verify-reset-token";
  String resetPassword = "$baseUrl/auth/reset-password";

  // Profile
  String profilUrl = "$baseUrl/profile";

  // Topic
  String topicsUrl = "$baseUrl/topics";

  // Conversation
  String conversationUrl = '$baseUrl/conversation';

  // Avatar
  String avatarUrl = '$baseUrl/avatars';

  // Rate
  String rateUrl = '$baseUrl/rates';

  // Scenario
  String scenarioUrl = '$baseUrl/scenarios';

  // Category
  String categoryUrl = '$baseUrl/categories';

  // PlayerId
  String playerId = "$baseUrl/notifications/update-one-signal-player-id";
}
