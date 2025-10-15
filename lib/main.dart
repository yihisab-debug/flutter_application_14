import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false;
  int attemptsLeft = 3;
  String errorMessage = '';

  final Map<String, Map<String, String>> users = {
    'admin': {'password': 'admin123', 'role': 'Администратор'},
    'manager': {'password': 'manager123', 'role': 'Менеджер'},
    'user': {'password': 'user123', 'role': 'Обычный пользователь'},
    'guest': {'password': 'guest123', 'role': 'Гость'},
  };

  void login() {
    final login = loginController.text.trim();
    final password = passwordController.text;

    if (users.containsKey(login) && users[login]!['password'] == password) {
      String role = users[login]!['role']!;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          pageBuilder: (context, _, __) => HomePage(role: role),
        ),
      );
    } else {
      setState(() {
        attemptsLeft--;
        if (attemptsLeft <= 0) {
          errorMessage = 'Превышено количество попыток. Попробуйте позже.';
        } else {
          errorMessage = 'Неправильный логин или пароль. Осталось попыток: $attemptsLeft';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = attemptsLeft <= 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Авторизация')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController,
              enabled: !isLocked,
              decoration: const InputDecoration(labelText: 'Логин'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: !showPassword,
              enabled: !isLocked,
              decoration: InputDecoration(
                labelText: 'Пароль',
                suffixIcon: IconButton(
                  icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLocked ? null : login,
              child: const Text('Войти'),
            ),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String role;

  const HomePage({super.key, required this.role});

  String getMessage() {
    switch (role) {
      case 'Администратор':
        return 'Добро пожаловать, Администратор!';
      case 'Менеджер':
        return 'Добро пожаловать, Менеджер!';
      case 'Обычный пользователь':
        return 'Привет, Пользователь!';
      case 'Гость':
        return 'Вы вошли как Гость (ограниченный доступ).';
      default:
        return 'Роль не распознана.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          getMessage(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
