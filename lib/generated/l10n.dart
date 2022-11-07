// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back to khazna!`
  String get welcome {
    return Intl.message(
      'Welcome back to khazna!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome,\n`
  String get wel {
    return Intl.message(
      'Welcome,\n',
      name: 'wel',
      desc: '',
      args: [],
    );
  }

  /// `Please fill your registered information below:`
  String get please {
    return Intl.message(
      'Please fill your registered information below:',
      name: 'please',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get have_acc {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'have_acc',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Forget password?`
  String get forget {
    return Intl.message(
      'Forget password?',
      name: 'forget',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Password is required for login`
  String get required {
    return Intl.message(
      'Password is required for login',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Password(Min. 6 Character)`
  String get valid_pass {
    return Intl.message(
      'Enter Valid Password(Min. 6 Character)',
      name: 'valid_pass',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Email`
  String get enter_email {
    return Intl.message(
      'Please Enter Your Email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter a valid email`
  String get valid_email {
    return Intl.message(
      'Please Enter a valid email',
      name: 'valid_email',
      desc: '',
      args: [],
    );
  }

  /// `First Name cannot be Empty`
  String get f_cannot_empty {
    return Intl.message(
      'First Name cannot be Empty',
      name: 'f_cannot_empty',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid name(Min. 3 Character)`
  String get valid_name {
    return Intl.message(
      'Enter Valid name(Min. 3 Character)',
      name: 'valid_name',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message(
      'First Name',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Second Name cannot be Empty`
  String get s_cannot_empty {
    return Intl.message(
      'Second Name cannot be Empty',
      name: 's_cannot_empty',
      desc: '',
      args: [],
    );
  }

  /// `Second Name`
  String get second_name {
    return Intl.message(
      'Second Name',
      name: 'second_name',
      desc: '',
      args: [],
    );
  }

  /// `Password is required !`
  String get r_required {
    return Intl.message(
      'Password is required !',
      name: 'r_required',
      desc: '',
      args: [],
    );
  }

  /// `Password don't match`
  String get dont_match {
    return Intl.message(
      'Password don\'t match',
      name: 'dont_match',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Your monthly income`
  String get income {
    return Intl.message(
      'Your monthly income',
      name: 'income',
      desc: '',
      args: [],
    );
  }

  /// `Your current balance`
  String get balance {
    return Intl.message(
      'Your current balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Trouble logging in?`
  String get trouble {
    return Intl.message(
      'Trouble logging in?',
      name: 'trouble',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and we will send you a link to get back into your account.`
  String get send_link {
    return Intl.message(
      'Enter your email and we will send you a link to get back into your account.',
      name: 'send_link',
      desc: '',
      args: [],
    );
  }

  /// `Email Verification`
  String get email_verification {
    return Intl.message(
      'Email Verification',
      name: 'email_verification',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email Format`
  String get invalid_format {
    return Intl.message(
      'Invalid Email Format',
      name: 'invalid_format',
      desc: '',
      args: [],
    );
  }

  /// `OTP sent !`
  String get otp_sent {
    return Intl.message(
      'OTP sent !',
      name: 'otp_sent',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get send_otp {
    return Intl.message(
      'Send OTP',
      name: 'send_otp',
      desc: '',
      args: [],
    );
  }

  /// `Otp required!`
  String get otp_required {
    return Intl.message(
      'Otp required!',
      name: 'otp_required',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get enter_otp {
    return Intl.message(
      'Enter OTP',
      name: 'enter_otp',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verified`
  String get otp_verified {
    return Intl.message(
      'OTP Verified',
      name: 'otp_verified',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for your patience`
  String get thanks {
    return Intl.message(
      'Thanks for your patience',
      name: 'thanks',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP`
  String get invalid_otp {
    return Intl.message(
      'Invalid OTP',
      name: 'invalid_otp',
      desc: '',
      args: [],
    );
  }

  /// `Please try again!`
  String get try_again {
    return Intl.message(
      'Please try again!',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Email required!`
  String get email_required {
    return Intl.message(
      'Email required!',
      name: 'email_required',
      desc: '',
      args: [],
    );
  }

  /// `My Plan`
  String get my_plan {
    return Intl.message(
      'My Plan',
      name: 'my_plan',
      desc: '',
      args: [],
    );
  }

  /// `This plan shows your daily, monthly \n allowance and saving point`
  String get this_plan {
    return Intl.message(
      'This plan shows your daily, monthly \n allowance and saving point',
      name: 'this_plan',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Allowance`
  String get monthly {
    return Intl.message(
      'Monthly Allowance',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Savings`
  String get savings {
    return Intl.message(
      'Savings',
      name: 'savings',
      desc: '',
      args: [],
    );
  }

  /// `Total amount`
  String get total {
    return Intl.message(
      'Total amount',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Daily allowance`
  String get daily {
    return Intl.message(
      'Daily allowance',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// ` SAR`
  String get sar {
    return Intl.message(
      ' SAR',
      name: 'sar',
      desc: '',
      args: [],
    );
  }

  /// `80%`
  String get e {
    return Intl.message(
      '80%',
      name: 'e',
      desc: '',
      args: [],
    );
  }

  /// `20%`
  String get t {
    return Intl.message(
      '20%',
      name: 't',
      desc: '',
      args: [],
    );
  }

  /// `100%`
  String get o {
    return Intl.message(
      '100%',
      name: 'o',
      desc: '',
      args: [],
    );
  }

  /// `Spending analytics`
  String get stats {
    return Intl.message(
      'Spending analytics',
      name: 'stats',
      desc: '',
      args: [],
    );
  }

  /// `Current balance`
  String get net_balance {
    return Intl.message(
      'Current balance',
      name: 'net_balance',
      desc: '',
      args: [],
    );
  }

  /// `Current balance`
  String get current_balance {
    return Intl.message(
      'Current balance',
      name: 'current_balance',
      desc: '',
      args: [],
    );
  }

  /// `Expected spending`
  String get expected_balance {
    return Intl.message(
      'Expected spending',
      name: 'expected_balance',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Privacy and security`
  String get privacy {
    return Intl.message(
      'Privacy and security',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Updates`
  String get updates {
    return Intl.message(
      'Updates',
      name: 'updates',
      desc: '',
      args: [],
    );
  }

  /// `Daily encouragements`
  String get daily_encouragements {
    return Intl.message(
      'Daily encouragements',
      name: 'daily_encouragements',
      desc: '',
      args: [],
    );
  }

  /// `Current balance`
  String get cb {
    return Intl.message(
      'Current balance',
      name: 'cb',
      desc: '',
      args: [],
    );
  }

  /// `Expected balance`
  String get eb {
    return Intl.message(
      'Expected balance',
      name: 'eb',
      desc: '',
      args: [],
    );
  }

  /// `Daily Spending Behaviour`
  String get dsb {
    return Intl.message(
      'Daily Spending Behaviour',
      name: 'dsb',
      desc: '',
      args: [],
    );
  }

  /// `Latest Transactions`
  String get daily_transaction {
    return Intl.message(
      'Latest Transactions',
      name: 'daily_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get dep {
    return Intl.message(
      'Deposit',
      name: 'dep',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal`
  String get ww {
    return Intl.message(
      'Withdrawal',
      name: 'ww',
      desc: '',
      args: [],
    );
  }

  /// `Select notification Date`
  String get snd {
    return Intl.message(
      'Select notification Date',
      name: 'snd',
      desc: '',
      args: [],
    );
  }

  /// `No custom notification yet`
  String get ncn {
    return Intl.message(
      'No custom notification yet',
      name: 'ncn',
      desc: '',
      args: [],
    );
  }

  /// `Custom notifications`
  String get cust {
    return Intl.message(
      'Custom notifications',
      name: 'cust',
      desc: '',
      args: [],
    );
  }

  /// `Last 5 SMS:`
  String get last_sms {
    return Intl.message(
      'Last 5 SMS:',
      name: 'last_sms',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `To achieve your goals, we advice you to follow the plan below:`
  String get achieve_goals {
    return Intl.message(
      'To achieve your goals, we advice you to follow the plan below:',
      name: 'achieve_goals',
      desc: '',
      args: [],
    );
  }

  /// `Daily Allowance`
  String get daily_allowance {
    return Intl.message(
      'Daily Allowance',
      name: 'daily_allowance',
      desc: '',
      args: [],
    );
  }

  /// `Add custom notifications`
  String get add_cus {
    return Intl.message(
      'Add custom notifications',
      name: 'add_cus',
      desc: '',
      args: [],
    );
  }

  /// `Notification title`
  String get notit {
    return Intl.message(
      'Notification title',
      name: 'notit',
      desc: '',
      args: [],
    );
  }

  /// `Enter notification title\n`
  String get ennotit {
    return Intl.message(
      'Enter notification title\n',
      name: 'ennotit',
      desc: '',
      args: [],
    );
  }

  /// `Notification body`
  String get nobod {
    return Intl.message(
      'Notification body',
      name: 'nobod',
      desc: '',
      args: [],
    );
  }

  /// `Enter Notification body\n`
  String get ennobod {
    return Intl.message(
      'Enter Notification body\n',
      name: 'ennobod',
      desc: '',
      args: [],
    );
  }

  /// `Select notification Date`
  String get no_date {
    return Intl.message(
      'Select notification Date',
      name: 'no_date',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_pass {
    return Intl.message(
      'New password',
      name: 'new_pass',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get old_pass {
    return Intl.message(
      'Old password',
      name: 'old_pass',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_pass {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_pass',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update_pass {
    return Intl.message(
      'Update',
      name: 'update_pass',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password with min 6 char length!`
  String get len {
    return Intl.message(
      'Please enter password with min 6 char length!',
      name: 'len',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get en_new_pass {
    return Intl.message(
      'Enter new password',
      name: 'en_new_pass',
      desc: '',
      args: [],
    );
  }

  /// `Enter old password`
  String get en_old_pass {
    return Intl.message(
      'Enter old password',
      name: 'en_old_pass',
      desc: '',
      args: [],
    );
  }

  /// `Enter confirmed password`
  String get en_confirm_pass {
    return Intl.message(
      'Enter confirmed password',
      name: 'en_confirm_pass',
      desc: '',
      args: [],
    );
  }

  /// `Password updated`
  String get pass_up {
    return Intl.message(
      'Password updated',
      name: 'pass_up',
      desc: '',
      args: [],
    );
  }

  /// `Password doesn't match`
  String get pass_wrong {
    return Intl.message(
      'Password doesn\'t match',
      name: 'pass_wrong',
      desc: '',
      args: [],
    );
  }

  /// `custom notification`
  String get custom_notification {
    return Intl.message(
      'custom notification',
      name: 'custom_notification',
      desc: '',
      args: [],
    );
  }

  /// `show_notification`
  String get show_notification {
    return Intl.message(
      'show_notification',
      name: 'show_notification',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
