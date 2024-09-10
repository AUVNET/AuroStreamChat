import 'package:auro_stream_chat/auro_stream_chat.dart';

import 'chat_service.dart';
import 'home_chats_screen.dart';
import 'package:flutter/material.dart';

void main() {
  AuroStreamChat.initialize(
    projectId: 'cfc6553ee457b7abfca578b896a3c406',
    apiKey: '831f702d4bf18ee086fec7cd.d396d8b8a7e0a8f27f3ce0740f42fe6e216528ca10370f018b45fe112e95bfe6d8bf001e21f2300bacf126ac345006a5425456b25c853f3be8aeed4bfff9db24e5ca9892f0b15657ae9585f7a42752c06048bee2ab7f3029cdbbf9378c7896dc52c52290403372.1adb898dd0777821db58c60b',
    port: '1028',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'AuroStream Chat',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuroStreamChatServices? auroStreamChatServices;
  final userController = TextEditingController();

  @override
  void initState() {
    auroStreamChatServices = AuroStreamChatServices();
    auroStreamChatServices!.connectServer();
    super.initState();
  }

  void connect(bool isCreate) {
    /// Should have unique String for user like username or id
    final username = userController.text.trim();
    if (username.isNotEmpty) {
      auroStreamChatServices!.initUsername(usernameId: username);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeChatsScreen(
            auroStreamChatServices: auroStreamChatServices!,
            isCreate: isCreate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'UserName',
              style: TextStyle(color: Color(0xff0445A2), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: userController,
              decoration: const InputDecoration(
                hintText: 'Enter your username..',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: const Color(0xff0445A2),
                  onPressed: () {
                    connect(true);
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                MaterialButton(
                  color: const Color(0xff0445A2),
                  onPressed: () {
                    connect(false);
                  },
                  child: const Text(
                    'Join',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
