import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yardify/mobile/database/messaging.dart';
import 'package:yardify/routes.dart';

class UserChat extends StatefulWidget {
  final String userId;
  final String userName;
  final String chatId;
  const UserChat({super.key, required this.userId, required this.userName, required this.chatId});

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String currentUserId = auth.currentUser!.uid;
    final String chatId = widget.chatId;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: MessagingService().getMessagesStream(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final data = msg.data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUserId;

                    return ListTile(
                      title: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.teal[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(data['message']),
                        ),
                      ),
                      subtitle: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: data['timestamp'] != null
                            ? Text(
                                DateFormat(
                                  'hh:mm a',
                                ).format(data['timestamp'].toDate()),
                                style: TextStyle(fontSize: 10),
                              )
                            : CircularProgressIndicator(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: () async {
                    final message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      await MessagingService().sendMessage(
                        chatId,
                        currentUserId,
                        widget.userId,
                        message,
                      );
                      await MessagingService().updateConversation(
                        currentUserId,
                        widget.userId,
                        message,
                      );
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
