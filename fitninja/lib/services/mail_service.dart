import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class MailService {
  static const String _username = String.fromEnvironment('MAIL_USERNAME', defaultValue: '');
  static const String _password = String.fromEnvironment('MAIL_PASSWORD', defaultValue: ''); // App Password

  static Future<void> sendVerificationOtp(String recipientEmail, String name, String otp) async {
    final smtpServer = gmail(_username, _password);

    final String htmlContent = '''
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; background-color: #0A0A0A; color: #ffffff; padding: 20px; border-radius: 12px; border: 1px solid #333;">
      <div style="text-align: center; margin-bottom: 20px;">
          <img src="https://i.ibb.co/9k2YLVKp/6ca0ebf9-5fa8-41f4-aedd-6025f9a2eaaf.png" alt="FitNinja Logo" style="width: 150px;">
      </div>
      <h2 style="color: #3b82f6; text-align: center;">Welcome to FitNinja, \$name!</h2>
      <p style="font-size: 16px; text-align: center; color: #A1A1AA;">You're one step away from unlocking AI-driven fitness protocols.</p>
      <div style="background-color: #1C1C1E; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0;">
        <span style="font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #fff;">\$otp</span>
      </div>
      <p style="font-size: 14px; text-align: center; color: #666;">Enter this 6-digit code in the app to verify your account. If you didn't request this, safely ignore this email.</p>
    </div>
    ''';

    final message = Message()
      ..from = Address(_username, 'FitNinja AI')
      ..recipients.add(recipientEmail)
      ..subject = 'FitNinja - Email Verification'
      ..html = htmlContent;

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      throw Exception('Failed to send Verification Email');
    }
  }
}
