import 'package:flutter/material.dart';

void main() {
  runApp(const MoodBloomApp());
}

const lavender = Color(0xFF8C72B8);
const deepLavender = Color(0xFF655080);
const paleLavender = Color(0xFFF1EAF9);
const milk = Color(0xFFFFFCFF);
const blush = Color(0xFFF8E9F0);
const ink = Color(0xFF51465F);
const muted = Color(0xFF91869D);

class MoodBloomApp extends StatelessWidget {
  const MoodBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodBloom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBF8FD),
        colorScheme: ColorScheme.fromSeed(seedColor: lavender, surface: milk),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: ink,
          elevation: 0,
        ),
      ),
      home: const BloomShell(),
    );
  }
}

class MoodEntry {
  final String emoji;
  final String label;
  final String note;
  final String time;
  final String date;

  const MoodEntry({
    required this.emoji,
    required this.label,
    required this.note,
    required this.time,
    required this.date,
  });
}

class BloomShell extends StatefulWidget {
  const BloomShell({super.key});

  @override
  State<BloomShell> createState() => _BloomShellState();
}

class _BloomShellState extends State<BloomShell> {
  int tab = 0;
  String mood = 'Not shared yet';
  String moodEmoji = '🌷';
  final List<MoodEntry> moodEntries = [];
  final List<String> flowers = ['🌷', '🌼', '🌸'];
  final List<String> memories = [];

  void setMood(String emoji, String label, String note) {
    setState(() {
      mood = label;
      moodEmoji = emoji;
      moodEntries.insert(
        0,
        MoodEntry(
          emoji: emoji,
          label: label,
          note: note.isEmpty ? 'No description added' : note,
          time: TimeOfDay.now().format(context),
          date: DateTime.now().toString().substring(0, 10),
        ),
      );
    });
  }

  void openPage(String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailPage(
          title: title,
          moodEntries: moodEntries,
          flowers: flowers,
          memories: memories,
          onMood: setMood,
          onAddFlower: (flower) => setState(() => flowers.add(flower)),
          onAddMemory: (memory) => setState(() => memories.insert(0, memory)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        mood: mood,
        moodEmoji: moodEmoji,
        moodCount: moodEntries.length,
        onOpen: openPage,
      ),
      MoodPage(mood: mood, moodEmoji: moodEmoji, onMood: setMood),
      GardenPage(flowers: flowers, onAdd: (f) => setState(() => flowers.add(f))),
      const GamesPage(),
      MorePage(onOpen: openPage),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        indicatorColor: paleLavender,
        selectedIndex: tab,
        onDestinationSelected: (index) => setState(() => tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Mood',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_florist_outlined),
            selectedIcon: Icon(Icons.local_florist),
            label: 'Garden',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports),
            label: 'Play',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class BloomPage extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const BloomPage({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: ink,
                    letterSpacing: -0.7,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(17),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: lavender.withOpacity(0.10),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: child,
    );
  }
}

Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 22),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: ink,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

Widget pillButton(String text, VoidCallback onTap, {IconData? icon}) {
  return FilledButton.tonalIcon(
    onPressed: onTap,
    icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 17),
    label: Text(text),
    style: FilledButton.styleFrom(
      foregroundColor: deepLavender,
      backgroundColor: paleLavender,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

class HomePage extends StatelessWidget {
  final String mood;
  final String moodEmoji;
  final int moodCount;
  final void Function(String) onOpen;

  const HomePage({
    super.key,
    required this.mood,
    required this.moodEmoji,
    required this.moodCount,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return BloomPage(
      title: 'Hello, sunshine ✨',
      trailing: const CircleAvatar(
        backgroundColor: paleLavender,
        child: Icon(Icons.person_outline, color: deepLavender),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A little space to be yourself.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE9DDF8), Color(0xFFFBEAF1), Color(0xFFFFF7F1)],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR LITTLE CHECK-IN',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.4,
                    color: muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'How is your heart\ntoday?',
                  style: TextStyle(
                    fontSize: 25,
                    height: 1.12,
                    color: deepLavender,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$moodEmoji  $mood',
                  style: const TextStyle(
                    color: deepLavender,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                pillButton(
                  'Check in now',
                  () => onOpen('Mood Space'),
                  icon: Icons.favorite,
                ),
              ],
            ),
          ),
          sectionTitle('Your day, softly'),
          Row(
            children: [
              Expanded(child: _statCard('Mood notes', '$moodCount', Icons.favorite_border)),
              const SizedBox(width: 11),
              Expanded(child: _statCard('Garden blooms', 'Growing', Icons.local_florist_outlined)),
            ],
          ),
          sectionTitle('Little spaces'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              _shortcut('📸', 'Photo check-in', 'Save today', () => onOpen('Daily Photo Check-in')),
              _shortcut('🐰', 'Your companion', 'Say hello', () => onOpen('Virtual Companion')),
              _shortcut('📖', 'Diary & memories', 'Keep a note', () => onOpen('Diary and Memories')),
              _shortcut('☁️', 'Calm corner', 'Take a pause', () => onOpen('Calm Corner')),
            ],
          ),
          sectionTitle('A note for today'),
          const GlassCard(
            child: Text(
              '“You are allowed to take life one gentle moment at a time.” 💜',
              style: TextStyle(color: ink, height: 1.5, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _statCard(String title, String value, IconData icon) {
  return GlassCard(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: lavender),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(color: ink, fontSize: 19, fontWeight: FontWeight.w800),
        ),
        Text(title, style: const TextStyle(color: muted, fontSize: 12)),
      ],
    ),
  );
}

Widget _shortcut(String emoji, String title, String subtitle, VoidCallback onTap) {
  return InkWell(
    borderRadius: BorderRadius.circular(22),
    onTap: onTap,
    child: GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 13)),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
        ],
      ),
    ),
  );
}

class MoodPage extends StatefulWidget {
  final String mood;
  final String moodEmoji;
  final void Function(String, String, String) onMood;

  const MoodPage({
    super.key,
    required this.mood,
    required this.moodEmoji,
    required this.onMood,
  });

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  String selected = '😊';
  String label = 'Happy';
  final note = TextEditingController();

  final options = const [
    ['😊', 'Happy'],
    ['🥰', 'Loved'],
    ['😌', 'Calm'],
    ['🥺', 'Sensitive'],
    ['😔', 'Sad'],
    ['😴', 'Tired'],
    ['😣', 'Stressed'],
    ['😡', 'Frustrated'],
    ['🌱', 'Hopeful'],
    ['🤍', 'Quiet'],
  ];

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BloomPage(
      title: 'Mood Space',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Whatever you feel is welcome here.', style: TextStyle(color: muted)),
          sectionTitle('Choose what feels closest'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.45,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, index) {
              final item = options[index];
              final active = selected == item[0];
              return InkWell(
                onTap: () => setState(() {
                  selected = item[0];
                  label = item[1];
                }),
                borderRadius: BorderRadius.circular(17),
                child: Container(
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFE9DDF8) : Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: active ? lavender : const Color(0xFFEDE7F1),
                      width: active ? 1.6 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item[0], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(item[1], style: const TextStyle(color: ink, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            },
          ),
          sectionTitle('Add a little context (optional)'),
          TextField(
            controller: note,
            maxLines: 3,
            decoration: _input('What is on your mind?'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                widget.onMood(selected, label, note.text.trim());
                note.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Your mood was added to this demo session 🌷')),
                );
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Share my mood'),
              style: FilledButton.styleFrom(
                backgroundColor: lavender,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              ),
            ),
          ),
          sectionTitle('Your latest check-in'),
          GlassCard(
            child: Row(
              children: [
                Text(widget.moodEmoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.mood,
                    style: const TextStyle(color: ink, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GardenPage extends StatelessWidget {
  final List<String> flowers;
  final void Function(String) onAdd;

  const GardenPage({super.key, required this.flowers, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return BloomPage(
      title: 'Virtual Garden',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Every little moment helps your garden grow.', style: TextStyle(color: muted)),
          const SizedBox(height: 18),
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEDE5FA), Color(0xFFF9EAF0), Color(0xFFE6EEDC)],
              ),
            ),
            child: Stack(
              children: [
                const Positioned(top: 18, left: 22, child: Text('☁️', style: TextStyle(fontSize: 30))),
                const Positioned(top: 38, right: 30, child: Text('✨', style: TextStyle(fontSize: 24))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7C99D).withOpacity(0.65),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                    ),
                  ),
                ),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 13,
                    runSpacing: 8,
                    children: flowers.map((f) => Text(f, style: const TextStyle(fontSize: 38))).toList(),
                  ),
                ),
              ],
            ),
          ),
          sectionTitle('Your collection'),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${flowers.length} little blooms',
                  style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 17),
                ),
                const SizedBox(height: 5),
                const Text('Add a flower to your garden.', style: TextStyle(color: muted)),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 10,
                  children: [
                    for (final flower in ['🌷', '🌼', '🌸', '🌻', '🪻'])
                      ActionChip(
                        label: Text(flower, style: const TextStyle(fontSize: 20)),
                        onPressed: () {
                          onAdd(flower);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('A new flower joined your garden!')),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  int coins = 25;
  int completed = 0;

  @override
  Widget build(BuildContext context) {
    return BloomPage(
      title: 'Play & Bloom',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            color: const Color(0xFFF0E8FA),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('YOUR PETAL COINS', style: TextStyle(fontSize: 10, color: muted, letterSpacing: 1.2)),
                      Text('$coins coins', style: const TextStyle(color: deepLavender, fontSize: 23, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          sectionTitle('Little quests'),
          _quest('🌤️', 'Take a mindful pause', 'Breathe slowly for one minute', completed >= 1, () => _completeQuest()),
          _quest('💌', 'Write a kind note', 'Leave yourself a gentle message', completed >= 2, () => _completeQuest()),
          _quest('🌷', 'Water your garden', 'Add a new flower to your space', completed >= 3, () => _completeQuest()),
          sectionTitle('Tiny games'),
          _gameCard('🌈', 'Colour of the day', 'Pick a colour that matches your mood.', () => _showGame(context, 'Choose a colour that feels like today. There is no wrong answer.')),
          _gameCard('🧩', 'One-minute puzzle', 'A tiny brain break.', () => _showGame(context, 'Your puzzle is to name three things that made you smile.')),
          _gameCard('🎁', 'Little surprise', 'Open a small kindness.', () => _showGame(context, 'Surprise! You deserve a soft and peaceful moment. 💜')),
        ],
      ),
    );
  }

  void _completeQuest() {
    setState(() {
      completed++;
      coins += 5;
    });
  }
}

Widget _quest(String emoji, String title, String description, bool done, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: GlassCard(
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
                Text(description, style: const TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: done ? null : onTap,
            icon: Icon(done ? Icons.check_circle : Icons.add_circle_outline, color: lavender),
          ),
        ],
      ),
    ),
  );
}

Widget _gameCard(String emoji, String title, String description, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: onTap,
      child: GlassCard(
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
                  Text(description, style: const TextStyle(color: muted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: lavender),
          ],
        ),
      ),
    ),
  );
}

void _showGame(BuildContext context, String text) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: milk,
      content: Text(text, style: const TextStyle(color: ink, height: 1.5)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Lovely'),
        ),
      ],
    ),
  );
}

class MorePage extends StatelessWidget {
  final void Function(String) onOpen;

  const MorePage({super.key, required this.onOpen});

  static const items = [
    ['📅', 'Mood History and Calendar', 'Look back at your check-ins'],
    ['📸', 'Daily Photo Check-in', 'A picture and a little note'],
    ['🐰', 'Virtual Companion', 'Care for your tiny friend'],
    ['📖', 'Diary and Memories', 'Private notes and keepsakes'],
    ['☁️', 'Calm Corner', 'Breathing and quiet moments'],
    ['💌', 'Messages', 'Supportive notes'],
    ['⚙️', 'Personal Space and Settings', 'Your app preferences'],
  ];

  @override
  Widget build(BuildContext context) {
    return BloomPage(
      title: 'Your spaces',
      child: Column(
        children: [
          const Text('Everything you need, tucked in one place.', style: TextStyle(color: muted)),
          const SizedBox(height: 14),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onOpen(item[1]),
                child: GlassCard(
                  child: Row(
                    children: [
                      Text(item[0], style: const TextStyle(fontSize: 27)),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item[1], style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
                            Text(item[2], style: const TextStyle(color: muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: lavender),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String title;
  final List<MoodEntry> moodEntries;
  final List<String> flowers;
  final List<String> memories;
  final void Function(String, String, String) onMood;
  final void Function(String) onAddFlower;
  final void Function(String) onAddMemory;

  const DetailPage({
    super.key,
    required this.title,
    required this.moodEntries,
    required this.flowers,
    required this.memories,
    required this.onMood,
    required this.onAddFlower,
    required this.onAddMemory,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  final controller = TextEditingController();
  late final AnimationController breathe;
  bool breathing = false;
  int petTaps = 0;

  @override
  void initState() {
    super.initState();
    breathe = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0.75,
      upperBound: 1.12,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget body;

    switch (widget.title) {
      case 'Mood History and Calendar':
        body = _history();
        break;
      case 'Daily Photo Check-in':
        body = _photo();
        break;
      case 'Virtual Companion':
        body = _pet();
        break;
      case 'Diary and Memories':
        body = _diary();
        break;
      case 'Calm Corner':
        body = _calm();
        break;
      case 'Messages':
        body = _messages();
        break;
      case 'Personal Space and Settings':
        body = _settings();
        break;
      case 'Mood Space':
        body = _moodSpace();
        break;
      default:
        body = _placeholder();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: body,
        ),
      ),
    );
  }

  Widget _history() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your feelings, remembered with kindness.', style: TextStyle(color: muted)),
        sectionTitle('This month'),
        GlassCard(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('M'), Text('T'), Text('W'), Text('T'), Text('F'), Text('S'), Text('S'),
                ],
              ),
              const SizedBox(height: 14),
              for (int row = 0; row < 5; row++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      7,
                      (column) {
                        final day = row * 7 + column + 1;
                        return Container(
                          width: 31,
                          height: 31,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: day % 4 == 0 ? paleLavender : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text('$day', style: const TextStyle(color: ink, fontSize: 11)),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        sectionTitle('Recent check-ins'),
        if (widget.moodEntries.isEmpty)
          const GlassCard(
            child: Text(
              'Your mood history will appear here after your first check-in.',
              style: TextStyle(color: muted),
            ),
          )
        else
          for (final entry in widget.moodEntries)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: GlassCard(
                child: Row(
                  children: [
                    Text(entry.emoji, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.label, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
                          Text(entry.note, style: const TextStyle(color: muted, fontSize: 12)),
                          Text(entry.date, style: const TextStyle(color: muted, fontSize: 10)),
                        ],
                      ),
                    ),
                    Text(entry.time, style: const TextStyle(color: muted, fontSize: 11)),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _photo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Keep a tiny snapshot of today.', style: TextStyle(color: muted)),
        const SizedBox(height: 18),
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: [Color(0xFFE9DDF8), Color(0xFFFFEDF3)]),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: deepLavender, size: 42),
              SizedBox(height: 10),
              Text('Your photo will live here', style: TextStyle(color: deepLavender, fontWeight: FontWeight.w700)),
              Text('Photo picker will be connected later', style: TextStyle(color: muted, fontSize: 12)),
            ],
          ),
        ),
        sectionTitle('A note with this moment'),
        TextField(controller: controller, maxLines: 3, decoration: _input('Write a little about today...')),
        const SizedBox(height: 14),
        pillButton(
          'Save check-in',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo check-in UI is ready. Photo storage comes next.')),
          ),
          icon: Icons.bookmark_add_outlined,
        ),
      ],
    );
  }

  Widget _pet() {
    return Column(
      children: [
        const Text('Your tiny friend is happy to see you.', style: TextStyle(color: muted)),
        const SizedBox(height: 22),
        GestureDetector(
          onTap: () => setState(() => petTaps++),
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(colors: [Color(0xFFEDE4FA), Color(0xFFFFEEF3)]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  petTaps % 3 == 0 ? '🐰' : petTaps % 3 == 1 ? '🐰💗' : '🐰✨',
                  style: const TextStyle(fontSize: 92),
                ),
                const Text('Mochi', style: TextStyle(color: deepLavender, fontWeight: FontWeight.w800, fontSize: 22)),
                const Text('Tap to give Mochi a cuddle', style: TextStyle(color: muted)),
              ],
            ),
          ),
        ),
        sectionTitle('Care activities'),
        Row(
          children: [
            Expanded(child: pillButton('Feed 🥕', () => setState(() => petTaps++))),
            const SizedBox(width: 9),
            Expanded(child: pillButton('Play 🎾', () => setState(() => petTaps++))),
          ],
        ),
        const SizedBox(height: 10),
        Text('Cuddles today: $petTaps', style: const TextStyle(color: muted)),
      ],
    );
  }

  Widget _diary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('A private little place for your thoughts.', style: TextStyle(color: muted)),
        sectionTitle('Write a memory'),
        TextField(controller: controller, maxLines: 5, decoration: _input('Dear diary...')),
        const SizedBox(height: 12),
        pillButton('Save to my diary', () {
          if (controller.text.trim().isNotEmpty) {
            widget.onAddMemory(controller.text.trim());
            controller.clear();
            setState(() {});
          }
        }),
        sectionTitle('Saved memories'),
        if (widget.memories.isEmpty)
          const GlassCard(child: Text('Your saved memories will appear here.', style: TextStyle(color: muted))),
        for (final memory in widget.memories)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: GlassCard(child: Text(memory, style: const TextStyle(color: ink, height: 1.5))),
          ),
        const SizedBox(height: 8),
        const Text(
          'Demo note: entries are held in memory only until the app closes. Firebase storage will be added later.',
          style: TextStyle(color: muted, fontSize: 11),
        ),
      ],
    );
  }

  Widget _calm() {
    return Column(
      children: [
        const Text('A quiet moment, just for you.', style: TextStyle(color: muted)),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: breathe,
          builder: (context, child) {
            return Transform.scale(
              scale: breathe.value,
              child: Container(
                height: 190,
                width: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFF8E9F0), Color(0xFFDCCCF0)],
                  ),
                  boxShadow: [
                    BoxShadow(color: lavender.withOpacity(0.18), blurRadius: 28),
                  ],
                ),
                child: const Center(
                  child: Text('🌷', style: TextStyle(fontSize: 60)),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 25),
        Text(
          breathing ? 'Breathe in... and out slowly' : 'Ready when you are',
          style: const TextStyle(
            color: deepLavender,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        pillButton(
          breathing ? 'Stop breathing exercise' : 'Start breathing exercise',
          () {
            setState(() => breathing = !breathing);
            if (breathing) {
              breathe.repeat(reverse: true);
            } else {
              breathe.stop();
              breathe.value = 1;
            }
          },
          icon: Icons.air,
        ),
        sectionTitle('Gentle reminders'),
        const GlassCard(
          child: Text(
            'Relax your shoulders. Unclench your jaw. You do not need to solve everything right now. 💜',
            style: TextStyle(color: ink, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _messages() {
    const supportiveMessages = [
      'You do not have to bloom every day. Rest is part of growing. 🌱',
      'A small step is still a step. I hope today is gentle with you. 💜',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Little reminders for the days you need them.', style: TextStyle(color: muted)),
        sectionTitle('Supportive notes'),
        for (final message in supportiveMessages)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(child: Text(message, style: const TextStyle(color: ink, height: 1.5))),
          ),
        sectionTitle('Your note'),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: _input('Write a kind message to yourself...'),
        ),
        const SizedBox(height: 12),
        pillButton('Keep this note', () {
          if (controller.text.trim().isNotEmpty) {
            widget.onAddMemory(controller.text.trim());
            controller.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved in this demo session.')),
            );
          }
        }),
      ],
    );
  }

  Widget _moodSpace() {
    const moodOptions = ['😊 Happy', '🥰 Loved', '😌 Calm', '🥺 Sensitive', '😔 Sad', '😴 Tired', '😣 Stressed', '🌱 Hopeful'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose a mood and share it when you are ready.', style: TextStyle(color: muted)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: moodOptions.map((item) => Chip(
            label: Text(item),
            backgroundColor: paleLavender,
          )).toList(),
        ),
        sectionTitle('Add a description'),
        TextField(controller: controller, decoration: _input('Optional note...')),
        const SizedBox(height: 12),
        pillButton('Share mood', () {
          widget.onMood('💜', 'Mood update', controller.text.trim());
          Navigator.pop(context);
        }),
      ],
    );
  }

  Widget _settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Make this space feel like yours.', style: TextStyle(color: muted)),
        sectionTitle('Your profile'),
        const GlassCard(
          child: Row(
            children: [
              CircleAvatar(backgroundColor: paleLavender, child: Icon(Icons.person, color: deepLavender)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Friend profile', style: TextStyle(color: ink, fontWeight: FontWeight.w800)),
                    Text('Account details will be connected with Firebase', style: TextStyle(color: muted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
        sectionTitle('Preferences'),
        _settingRow(Icons.notifications_none, 'Notifications', 'Mood and message updates'),
        _settingRow(Icons.lock_outline, 'Privacy', 'Choose what you share'),
        _settingRow(Icons.palette_outlined, 'Appearance', 'Lavender Milk theme'),
        _settingRow(Icons.help_outline, 'About MoodBloom', 'A gentle space to grow'),
      ],
    );
  }

  Widget _placeholder() {
    return const Column(
      children: [
        Text('A new little space is growing here.', style: TextStyle(color: muted)),
        SizedBox(height: 20),
        GlassCard(child: Center(child: Text('🌷', style: TextStyle(fontSize: 60)))),
      ],
    );
  }
}

InputDecoration _input(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.all(16),
  );
}

Widget _settingRow(IconData icon, String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: GlassCard(
      child: Row(
        children: [
          Icon(icon, color: lavender),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
                Text(subtitle, style: const TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: muted),
        ],
      ),
    ),
  );
}
