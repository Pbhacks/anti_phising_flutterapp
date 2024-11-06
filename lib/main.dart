import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/phising_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const AntiPhishingApp());
}

String? pstatus;

class AntiPhishingApp extends StatefulWidget {
  const AntiPhishingApp({super.key});

  @override
  _AntiPhishingAppState createState() => _AntiPhishingAppState();
}

class _AntiPhishingAppState extends State<AntiPhishingApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokyo 2025 Olympics Anti-Phishing App',
      themeMode: _themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardColor: const Color(0xFF2D2D2D),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Color(0xFF64B5F6),
          surface: Color(0xFF2D2D2D),
          background: Color(0xFF1A1A1A),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey[200],
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Color(0xFF64B5F6),
          surface: Colors.white,
          background: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: HomeScreen(toggleTheme: _toggleTheme),
    );
  }
}

void permission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.storage,
    Permission.contacts,
    Permission.photos,
  ].request();

  if (statuses.values.every((status) => status.isGranted)) {
    pstatus = 'All permissions granted';
  } else {
    pstatus = 'Some permissions denied';
  }
}

class HomeScreen extends StatelessWidget {
  final Function(bool) toggleTheme;

  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Anti-Phishing App'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/tokyo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome to the Tokyo 2025 Olympics\nAnti-Phishing App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildMenuCard(
                  context,
                  'Phishing Detection',
                  'Analyze emails and links for potential threats',
                  Icons.security,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhishingDetectionScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuCard(
                  context,
                  'User Education',
                  'Learn how to protect yourself from phishing attacks',
                  Icons.school,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserEducationScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuCard(
                  context,
                  'Settings',
                  'Configure app preferences and automation',
                  Icons.settings,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(toggleTheme: toggleTheme),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhishingDetectionScreen extends StatefulWidget {
  const PhishingDetectionScreen({super.key});

  @override
  _PhishingDetectionScreenState createState() => _PhishingDetectionScreenState();
}

class _PhishingDetectionScreenState extends State<PhishingDetectionScreen> {
  final TextEditingController _emailController = TextEditingController();
  PhishingAnalysisResult? _result;
  bool _isLoading = false;
  bool _serverConnected = false;

  @override
  void initState() {
    super.initState();
    _checkServerConnection();
    permission();
  }

  Future<void> _checkServerConnection() async {
    final isConnected = await PhishingService.checkServerHealth();
    setState(() {
      _serverConnected = isConnected;
    });
  }

  Future<void> _analyzeEmail() async {
    if (!_serverConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Server is not connected. Please try again later.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final result = await PhishingService.analyzeEmail(_emailController.text);
      setState(() {
        _result = result;
        if (result.isPhishing) {
          _showAlert(context, 'Phishing Alert', result.message);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Phishing Detection'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              _serverConnected ? Icons.cloud_done : Icons.cloud_off,
              color: _serverConnected ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _emailController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Paste Email Content Here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _analyzeEmail,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.search),
              label: Text(_isLoading ? 'Analyzing...' : 'Analyze Email'),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _result!.isPhishing
                                ? Icons.warning
                                : Icons.check_circle,
                            color:
                                _result!.isPhishing ? Colors.red : Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _result!.message,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _result!.isPhishing
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Confidence Level: ${_result!.confidenceLevel}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Individual Model Predictions:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._result!.modelPredictions.entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key),
                              Text(
                                '${(e.value * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

class UserEducationScreen extends StatelessWidget {
  final List<Map<String, String>> videoLinks = [
    {
      "title": "Understanding Phishing Attacks",
      "url": "https://youtu.be/XBkzBrXlle0"
    },
    {
      "title": "How to Recognize Phishing Emails",
      "url": "https://youtu.be/o0btqyGWIQw"
    },
  ];

  UserEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('User Education'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How to Prevent Phishing Attacks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    10,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getPreventionTip(index),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Educational Videos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...videoLinks.map((link) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () => _launchURL(link['url']!),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                link['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.open_in_new,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String _getPreventionTip(int index) {
    final tips = [
      'Be Skeptical of Unknown Senders',
      'Verify Links Before Clicking',
      'Avoid Sharing Personal Information',
      'Use Strong, Unique Passwords',
      'Enable Two-Factor Authentication (2FA)',
      'Keep Software Updated',
      'Educate Yourself and Others',
      'Report Suspicious Activity',
      'Be Wary of Urgent or Threatening Language',
      'Check for Grammar and Spelling Errors',
    ];
    return tips[index];
  }

  void _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

class SettingsScreen extends StatefulWidget {
  final Function(bool) toggleTheme;

  const SettingsScreen({super.key, required this.toggleTheme});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _automationEnabled = false;
  bool _darkModeEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoScanEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    'Dark Mode',
                    'Enable dark theme for the app',
                    Icons.dark_mode,
                    _darkModeEnabled,
                    (value) {
                      setState(() {
                        _darkModeEnabled = value;
                        widget.toggleTheme(value);
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    'Notifications',
                    'Receive alerts about potential threats',
                    Icons.notifications,
                    _notificationsEnabled,
                    (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    'Auto-Scan',
                    'Automatically scan incoming links',
                    Icons.security,
                    _autoScanEnabled,
                    (value) {
                      setState(() {
                        _autoScanEnabled = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    'Enable Automation',
                    'Allow automated scanning and protection',
                    Icons.auto_awesome,
                    _automationEnabled,
                    (value) {
                      setState(() {
                        _automationEnabled = value;
                      });
                      if (_automationEnabled) {
                        _startAutomation();
                      } else {
                        _stopAutomation();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tokyo 2025 Olympics Anti-Phishing App\nVersion 1.0.0',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Permission Status: ${pstatus ?? "Unknown"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  

  Widget _buildSettingTile(String title, String subtitle, IconData icon,
      bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    );
  }

  void _startAutomation() {
    // Implement automation start logic
    print('Automation started');
  }

  void _stopAutomation() {
    // Implement automation stop logic
    print('Automation stopped');
  }
}