import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yardify/mobile/database/messaging.dart';
import 'package:yardify/mobile/screens/messaging/user_chat.dart';
import 'package:yardify/routes.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String formatTimestamp(Timestamp? timestamp) {
      if (timestamp == null) return 'Unknown';

      try {
        DateTime dateTime = timestamp.toDate();
        DateTime now = DateTime.now();

        Duration diff = now.difference(dateTime);

        if (diff.inSeconds < 60) {
          return 'Just now';
        } else if (diff.inMinutes < 60) {
          return '${diff.inMinutes} min ago';
        } else if (diff.inHours < 24) {
          return '${diff.inHours} h ago';
        } else if (diff.inDays < 7) {
          return '${diff.inDays} d ago';
        } else {
          // Format date for older messages
          return DateFormat('MMM dd, yyyy').format(dateTime);
        }
      } catch (e) {
        return 'Invalid date';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Messages", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: MessagingService().getUserChatsStream(
                auth.currentUser!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) return Text('No Messages');
                final chats = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ListTile(
                      title: Text(chat['userName'] ?? 'Unknown'),
                      subtitle: Text(chat['lastMessage'] ?? ''),
                      trailing: Column(
                        children: [
                          Icon(Icons.abc),
                          Text(formatTimestamp(chat['lastMessageTime'])),
                        ],
                      ),
                      onTap: () {
                        // Navigate to chat detail screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserChat(
                              chatId: chat['chatId'],
                              userId: chat['userId'],
                              userName: chat['userName'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
