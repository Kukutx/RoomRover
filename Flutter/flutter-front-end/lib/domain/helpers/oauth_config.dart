import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OauthConfig {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static String get redirectUri {
    if (kIsWeb) {
      return "http://localhost:30000/";
    } else {
      return "https://login.live.com/oauth20_desktop.srf";
    }
  }

  static final Config config = Config(
    clientId: "46c7f064-2907-428b-808e-2d684a26d23e",
    tenant: "552bed02-4512-450c-858d-84cfe2b4186d",
    scope: "User.Read profile email openid offline_access",
    navigatorKey: navigatorKey,
    redirectUri: redirectUri,
    webUseRedirect: false,
  );

  static final AadOAuth aadOAuth = AadOAuth(config);
}
