import 'package:flutter/material.dart';

void main() {
  runApp(const GamerXApp());
}

class GamerXApp extends StatelessWidget {
  const GamerXApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF4052D6);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F0F0F), elevation: 0),
        colorScheme: const ColorScheme.dark(primary: brandColor, secondary: brandColor),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF161616),
          selectedItemColor: brandColor,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// 1. DATA MODEL
class Post {
  final String username;
  final String text;
  final String imageUrl;
  final String views;
  final String tag;
  const Post({required this.username, required this.text, required this.imageUrl, required this.views, required this.tag});
}

// 2. MAIN SCREEN (The Controller)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _showCreatePost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text("New Post", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const TextField(
                autofocus: true,
                maxLines: 4,
                decoration: InputDecoration(hintText: "Share your gaming moments...", border: InputBorder.none),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4052D6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Post"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    switch (_selectedIndex) {
      case 0: currentBody = const TabbedFeedView(); break;
      case 1: currentBody = const BookmarksView(); break;
      case 3: currentBody = const MessagesView(); break;
      case 4: currentBody = const ProfileView(); break;
      default: currentBody = const TabbedFeedView();
    }

    return Scaffold(
      body: currentBody,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        onTap: (index) {
          if (index == 2) {
            _showCreatePost();
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark_rounded), label: ""),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF4052D6), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
            label: "",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications_none_rounded), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: ""),
        ],
      ),
    );
  }
}

// 3. HOME VIEW WITH SEARCH + TABS
class TabbedFeedView extends StatelessWidget {
  const TabbedFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("SaveStateSocial", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search community...",
                        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const TabBar(
                  indicatorColor: Color(0xFF4052D6),
                  tabs: [Tab(text: "Following"), Tab(text: "Home"), Tab(text: "News")],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _topicChip("All", true),
                  _topicChip("Action", false),
                  _topicChip("RPG", false),
                  _topicChip("Guides", false),
                  _topicChip("Art", false),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  FeedList(isNews: false),
                  FeedList(isNews: false),
                  FeedList(isNews: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topicChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: isSelected ? const Color(0xFF4052D6) : const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

// 4. POST CARD COMPONENT
class HoYoPostCard extends StatelessWidget {
  final Post post;
  const HoYoPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF161616),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF4052D6), child: Icon(Icons.person, color: Colors.white)),
            title: Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text("3h ago", style: TextStyle(fontSize: 11, color: Colors.grey)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4052D6)), borderRadius: BorderRadius.circular(20)),
              child: const Text("Follow", style: TextStyle(color: Color(0xFF4052D6), fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text("# ${post.tag}", style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Text(post.text, style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 220),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.remove_red_eye_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(post.views, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.mode_comment_outlined, size: 20, color: Colors.grey),
                const SizedBox(width: 20),
                const Icon(Icons.thumb_up_outlined, size: 20, color: Colors.grey),
                const SizedBox(width: 20),
                const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
              ],
            ),
          ),
          const Divider(color: Colors.white10, thickness: 1, height: 1), // The requested separator
        ],
      ),
    );
  }
}

// 5. DATA FEED LOGIC
class FeedList extends StatelessWidget {
  final bool isNews;
  const FeedList({super.key, required this.isNews});

  @override
  Widget build(BuildContext context) {
    if (isNews) {
      return ListView(
        children: const [
          HoYoPostCard(post: Post(username: "PlayStation", text: "God of War Trilogy Remake is officially in development. Experience the Greek era in full 4K.", imageUrl: "https://picsum.photos/id/20/600/400", views: "2.4M", tag: "Official")),
        ],
      );
    }
    return ListView(
      children: const [
        HoYoPostCard(post: Post(username: "GamerVibes", text: "Just hitting the mid-game in Elden Ring. This view is breathtaking.", imageUrl: "https://picsum.photos/id/15/600/400", views: "15k", tag: "Elden Ring")),
        HoYoPostCard(post: Post(username: "PixelArtist", text: "Working on some fan art for the new trilogy remake!", imageUrl: "https://picsum.photos/id/26/600/400", views: "8k", tag: "Fan Art")),
      ],
    );
  }
}

// 6. COLLECTIONS, NOTIFICATIONS, AND PROFILE
class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("My Collections")),
    body: const HoYoPostCard(post: Post(username: "Endfield", text: "Arknights Endfield Technical Test - Guide and Walkthrough.", imageUrl: "https://picsum.photos/id/30/600/400", views: "89k", tag: "Guide")),
  );
}

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Notifications")),
    body: ListView(
      children: [
        _notifTile(Icons.system_update, "System", "Update 2.0 is now available!"),
        _notifTile(Icons.favorite, "Activity", "PixelArtist liked your post."),
        _notifTile(Icons.campaign, "Event", "Join the God of War Trilogy Discussion!"),
      ],
    ),
  );

  Widget _notifTile(IconData icon, String title, String msg) => ListTile(
    leading: CircleAvatar(backgroundColor: const Color(0xFF1E1E1E), child: Icon(icon, color: const Color(0xFF4052D6), size: 20)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    subtitle: Text(msg, style: const TextStyle(fontSize: 12)),
  );
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF4052D6);
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(height: 160, decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage("https://picsum.photos/id/35/600/200"), fit: BoxFit.cover))),
              Positioned(bottom: -40, child: CircleAvatar(radius: 44, backgroundColor: const Color(0xFF0F0F0F), child: CircleAvatar(radius: 40, backgroundImage: NetworkImage("https://picsum.photos/id/64/200")))),
            ],
          ),
          const SizedBox(height: 50),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text("Pablo_Jab_Official", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(width: 5), Icon(Icons.verified, color: brandColor, size: 18)]),
          const Text("@moe_lester", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), decoration: BoxDecoration(color: brandColor.withOpacity(0.1), border: Border.all(color: brandColor), borderRadius: BorderRadius.circular(10)), child: const Text("Lv. 42 Grandmaster", style: TextStyle(color: brandColor, fontSize: 10, fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.all(20), child: Text("Exploring digital worlds since '99.", textAlign: TextAlign.center, style: TextStyle(fontSize: 13))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _stat("1.2k", "Followers"), const SizedBox(width: 40), _stat("450", "Following"),
          ]),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
            itemCount: 9,
            itemBuilder: (context, index) => Container(color: Colors.white10, child: Image.network("https://picsum.photos/id/${index + 10}/200", fit: BoxFit.cover)),
          )
        ],
      ),
    );
  }
  Widget _stat(String val, String lab) => Column(children: [Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(lab, style: const TextStyle(color: Colors.grey, fontSize: 11))]);
}