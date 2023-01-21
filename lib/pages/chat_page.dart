import 'package:chatapp_supabase/common/constants.dart';
import 'package:chatapp_supabase/components/chat_bubble.dart';
import 'package:chatapp_supabase/components/message_bar.dart';
import 'package:chatapp_supabase/models/message.dart';
import 'package:chatapp_supabase/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class ChatPage extends HookWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCache = useState<Map<String, Profile>>({});
    Future<void> loadProfileCache(String profileId) async {
      if (profileCache.value[profileId] != null) {
        return;
      }

      final data =
          await supabase.from('profiles').select().eq('id', profileId).single();
      final profile = Profile.fromMap(data);

      profileCache.value[profileId] = profile;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('聊天室'),
        actions: [
          IconButton(
            onPressed: () => {
              supabase.auth.signOut(),
              Get.offNamedUntil('/login', (route) => false)
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: HookBuilder(
          builder: (context) {
            final stream = useMemoized(
              () => supabase
                  .from('messages')
                  .stream(primaryKey: ['id'])
                  .order('created_at')
                  .map((maps) => maps
                      .map((map) => Message.fromMap(
                          map: map, myUserId: supabase.auth.currentUser!.id))
                      .toList()),
            );

            final snapshot = useStream(stream);

            if (snapshot.hasData) {
              final messages = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? const Center(
                            child: Text('Start your conversation now :)'),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              loadProfileCache(message.profileId);
                              return ChatBubble(
                                message: message,
                                profile: profileCache.value[message.profileId],
                              );
                            },
                          ),
                  ),
                  const MessageBar(),
                ],
              );
            } else {
              return preloader;
            }
          },
        ),
      ),
    );
  }
}
