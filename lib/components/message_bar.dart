import 'package:chatapp_supabase/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageBar extends HookWidget {
  const MessageBar({super.key});

  @override
  Widget build(BuildContext context) {
    final messageController = useTextEditingController();
    void submitMessage() async {
      final text = messageController.text;
      final myUserId = supabase.auth.currentUser!.id;
      if (text.isEmpty) {
        return;
      }
      messageController.clear();

      try {
        await supabase
            .from('messages')
            .insert({'profile_id': myUserId, 'content': text});
      } on PostgrestException catch (e) {
        context.showErrorSnackBar(message: e.message);
      } catch (e) {
        context.showErrorSnackBar(message: unexpectedErrorMessage);
      }
    }

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  controller: messageController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: '请各位文明发言~',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: submitMessage,
                icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
