import 'dart:math';

import 'chat_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final AuroStreamChatServices auroStreamChatServices;
  final bool isCreate;

  const ChatScreen({
    super.key,
    required this.isCreate,
    required this.auroStreamChatServices,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuroStreamChatServices? auroStreamChatServices;
  final messageController = TextEditingController();
  final String roomId = '777';
  bool isTyping = false;

  @override
  void initState() {
    final messages = getMessages();
    auroStreamChatServices = widget.auroStreamChatServices;
    auroStreamChatServices!.initRoomService(
      messagesList: messages,
      targetRoomId: roomId,
      isCreateBoolean: widget.isCreate,
    );
    auroStreamChatServices!.initUpdateUI(
      update: () {
        setState(() {});
      },
    );
    super.initState();
  }

  /// Get your current messages from your database
  List<Message> getMessages() {
    return [];
  }

  String generateRandomId(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random.secure();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: const Color(0xff0445A2),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Auro Stream',
          style: TextStyle(
            color: Color(0xff0445A2),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: MaterialButton(
            color: Colors.white,
            shape: const CircleBorder(),
            onPressed: () {
              auroStreamChatServices!.leaveRoom();
              Navigator.pop(context);
            },
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: auroStreamChatServices!.messages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Start a conversation now between you and team Auro Stream',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final msg = auroStreamChatServices!.messages[index];
                        if (msg.sender == auroStreamChatServices!.username) {
                          return buildMyMessage(
                              auroStreamChatServices!.messages[index]);
                        } else {
                          return buildMessage(
                              auroStreamChatServices!.messages[index]);
                        }
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: auroStreamChatServices!.messages.length,
                    ),
                  ),
          ),
          if (auroStreamChatServices!.typingList.isNotEmpty)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  "${auroStreamChatServices!.typingList.join(", ")} typing...",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          border: const OutlineInputBorder(),
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.attachment)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && !isTyping) {
                            auroStreamChatServices!.startTyping();
                            isTyping = true;
                          } else if (val.isEmpty && isTyping) {
                            auroStreamChatServices!.stopTyping();
                            isTyping = false;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    minWidth: 40,
                    color: const Color(0xff0445A2),
                    onPressed: () {
                      if (messageController.text.trim().isNotEmpty) {
                        final id = generateRandomId(7);
                        final message = Message(
                          id: id,
                          messageText: messageController.text.trim(),
                          sender: auroStreamChatServices!.username!,
                          date: DateTime.now(),
                        );
                        auroStreamChatServices!.sendMessage(message);
                        if (isTyping) {
                          auroStreamChatServices!.stopTyping();
                          isTyping = false;
                        }
                        messageController.clear();
                        setState(() {});
                      }
                    },
                    child: const Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(Message? model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              bottomStart: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${model!.sender}:"),
              Text(model.messageText),
            ],
          ),
        ),
      );

  Widget buildMyMessage(Message model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 140,
                    color: Colors.transparent,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                final editedMessage =
                                    await showEditMessageBottomSheet(
                                        context, model.messageText);
                                if (editedMessage != null &&
                                    editedMessage != model.messageText) {
                                  final newMessage = Message(
                                    id: model.id,
                                    messageText: editedMessage,
                                    isEdited: true,
                                    sender: model.sender,
                                    date: model.date,
                                  );

                                  auroStreamChatServices!
                                      .editMessage(newMessage);
                                  setState(() {});
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.settings),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                auroStreamChatServices!.deleteMessage(model.id);
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${model.sender}:"),
                Text(model.messageText),
              ],
            ),
          ),
        ),
      );

  Future<String?> showEditMessageBottomSheet(
      BuildContext context, String initialMessage) async {
    return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController messageController =
            TextEditingController(text: initialMessage);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Edit Message',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.pop(context, messageController.text);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
