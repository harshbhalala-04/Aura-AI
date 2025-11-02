import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final void Function(String) onSend;
  final VoidCallback onVoice;

  const ChatInput({required this.onSend, required this.onVoice, Key? key}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _ctrl = TextEditingController();

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ]),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: widget.onVoice,
            ),
            Expanded(
              child: TextField(
                controller: _ctrl,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.send), onPressed: _send),
          ],
        ),
      ),
    );
  }
}
