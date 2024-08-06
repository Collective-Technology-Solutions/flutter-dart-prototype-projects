import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:note_taking_app/note.dart';

class EmailService {
  Future<void> sendEmail(String recipient, List<Note> notes) async {
    final email = Email(
      body: notes.map((note) => 'Title: ${note.filename}\n\n${note.content}').join('\n\n'),
      subject: 'Notes',
      recipients: [recipient],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error sending email: $error');
    }
  }
}
