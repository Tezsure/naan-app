import 'package:get/get.dart';

import '../modules/backup_wallet_page/bindings/backup_wallet_binding.dart';
import '../modules/backup_wallet_page/views/backup_wallet_view.dart';
import '../modules/biometric_page/bindings/biometric_page_binding.dart';
import '../modules/biometric_page/views/biometric_page_view.dart';
import '../modules/create_profile_page/bindings/create_profile_page_binding.dart';
import '../modules/create_profile_page/views/create_profile_page_view.dart';
import '../modules/create_wallet_page/bindings/create_wallet_page_binding.dart';
import '../modules/create_wallet_page/views/create_wallet_page_view.dart';
import '../modules/home_page/bindings/home_page_binding.dart';
import '../modules/home_page/views/home_page_view.dart';
import '../modules/home_page/widgets/accounts_widget/bindings/accounts_widget_binding.dart';
import '../modules/home_page/widgets/accounts_widget/views/accounts_widget_view.dart';
import '../modules/home_page/widgets/delegate_widget/bindings/delegate_widget_binding.dart';
import '../modules/home_page/widgets/delegate_widget/views/delegate_widget_view.dart';
import '../modules/home_page/widgets/info_stories/models/story_page/bindings/story_page_binding.dart';
import '../modules/home_page/widgets/info_stories/models/story_page/views/story_page_view.dart';
import '../modules/import_wallet_page/bindings/import_wallet_page_binding.dart';
import '../modules/import_wallet_page/views/import_wallet_page_view.dart';
import '../modules/passcode_page/bindings/passcode_page_binding.dart';
import '../modules/passcode_page/views/passcode_page_view.dart';
import '../modules/onboarding_page/bindings/onboarding_page_binding.dart';
import '../modules/onboarding_page/views/onboarding_page_view.dart';
import '../modules/settings_page/bindings/settings_page_binding.dart';
import '../modules/settings_page/views/settings_page_view.dart';
import '../modules/verify_phrase_page/bindings/verify_phrase_page_binding.dart';
import '../modules/verify_phrase_page/views/verify_phrase_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () => const HomePageView(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_WALLET_PAGE,
      page: () => const CreateWalletPageView(),
      binding: CreateWalletPageBinding(),
    ),
    GetPage(
      name: _Paths.PASSCODE_PAGE,
      page: () => const PasscodePageView(),
      binding: PasscodePageBinding(),
    ),
    GetPage(
      name: _Paths.BIOMETRIC_PAGE,
      page: () => const BiometricPageView(),
      binding: BiometricPageBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PROFILE_PAGE,
      page: () => const CreateProfilePageView(),
      binding: CreateProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_PAGE,
      page: () => const OnboardingPageView(),
      binding: OnboardingPageBinding(),
    ),
    GetPage(
      name: _Paths.BACKUP_WALLET,
      page: () => const BackupWalletView(),
      binding: BackupWalletBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_PHRASE_PAGE,
      page: () => const VerifyPhrasePageView(),
      binding: VerifyPhrasePageBinding(),
    ),
    GetPage(
      name: _Paths.IMPORT_WALLET_PAGE,
      page: () => const ImportWalletPageView(),
      binding: ImportWalletPageBinding(),
    ),
    GetPage(
      name: _Paths.STORY_PAGE,
      page: () => const StoryPageView(profileImagePath: [], storyTitle: []),
      binding: StoryPageBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNTS_WIDGET,
      page: () => const AccountsWidget(),
      binding: AccountsWidgetBinding(),
    ),
    GetPage(
      name: _Paths.DELEGATE_WIDGET,
      page: () => const DelegateWidget(),
      binding: DelegateWidgetBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS_PAGE,
      page: () => const SettingsPageView(),
      binding: SettingsPageBinding(),
    ),
  ];
}
