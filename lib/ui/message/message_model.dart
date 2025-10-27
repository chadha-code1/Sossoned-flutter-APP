//import 'package:first_app/models/user_model.dart';
import 'package:first_app/models/user.dart';

class Message {
  UserData sender;
  String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  String text;

  bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

// YOU - current user
UserData currentUser = UserData(uid: '0', email: 'Current User');

// USERS

final UserData james = UserData(uid: '2', email: 'James');

// FAVORITE CONTACTS

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: james,
    time: '5:30 PM',
    text:
        'Oui, Nous avons précisé le montant du dossier N 084534. Vous pouvez payer à l\'établissement la plus proche',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'est ce que il y a d\'avancement ce le dossier 084534 ?',
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:45 PM',
    text: ':)',
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:15 PM',
    text: 'c\'est notre travail',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Merci',
    unread: true,
  ),
  Message(
    sender: james,
    time: '2:00 PM',
    text: 'Le date est le 1/6/2021',
    unread: true,
  ),
];
