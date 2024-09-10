import 'chat_screen.dart';
import 'chat_service.dart';
import 'package:flutter/material.dart';

class HomeChatsScreen extends StatefulWidget {
  final AuroStreamChatServices auroStreamChatServices;
  final bool isCreate;

  const HomeChatsScreen({
    super.key,
    required this.isCreate,
    required this.auroStreamChatServices,
  });

  @override
  State<HomeChatsScreen> createState() => _HomeChatsScreenState();
}

class _HomeChatsScreenState extends State<HomeChatsScreen> {
  final searchEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 75),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: searchEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Search'),
                  border: OutlineInputBorder(),
                  prefix: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      color: Color(0xff14213D),
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  auroStreamChatServices:
                                      widget.auroStreamChatServices,
                                  isCreate: widget.isCreate,
                                ),
                              ),
                            );
                          },
                          child: const CustomItemChat());
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 24,
                    ),
                    itemCount: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomItemChat extends StatelessWidget {
  const CustomItemChat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Auro Stream',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xff14213D),
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                'Hi, morning too Andrew!',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            Text(
              'Dec 18, 2024',
              style: TextStyle(fontSize: 14, color: Colors.black),
            )
          ],
        )
      ],
    );
  }
}
