import 'package:flutter/material.dart';

void main() {
  runApp(const Lab6App());
}

// Цвета
const Color kPrimary = Color(0xFF111827);
const Color kAccent = Color(0xFF3B5BFD);
const Color kError = Color(0xFFE5484D);
const Color kSuccess = Color(0xFF16A34A);
const Color kBackground = Color(0xFFF5F6FA);
const Color kBorder = Color(0xFFE5E7EB);
const Color kTextSecondary = Color(0xFF6B7280);

// Приложение
class Lab6App extends StatelessWidget {
  const Lab6App({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: kBorder),
    );

    return MaterialApp(
      title: 'LAB 6 — Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAccent,
          primary: kPrimary,
          error: kError,
        ),
        scaffoldBackgroundColor: kBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBackground,
          foregroundColor: kPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        // Стиль полей формы
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: kAccent, width: 1.6),
          ),
          errorBorder: border.copyWith(
            borderSide: const BorderSide(color: kError),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: const BorderSide(color: kError, width: 1.6),
          ),
        ),
      ),
      home: const RegistrationScreen(),
    );
  }
}

// Роль пользователя
enum UserRole {
  student('Student', Icons.school_rounded),
  teacher('Teacher', Icons.work_rounded),
  developer('Developer', Icons.code_rounded);

  const UserRole(this.label, this.icon);

  final String label;
  final IconData icon;
}

// Пользователь
class UserProfile {
  final String fullName;
  final String email;
  final UserRole role;
  final bool subscribed;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.role,
    required this.subscribed,
  });

  String get firstName => fullName.split(' ').first;
}

// Проверки полей
String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your full name';
  }
  return null;
}

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Please enter your email';
  if (!email.contains('@') || !email.contains('.')) {
    return 'Enter a valid email, e.g. name@narxoz.kz';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Please enter a password';
  if (value.length < 6) return 'Password must be at least 6 characters';
  return null;
}

// Экран регистрации
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Ключ формы
  final _formKey = GlobalKey<FormState>();

  // Контроллеры полей
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // Состояние
  UserRole? _role;
  bool _acceptedTerms = false;
  bool _subscribe = true;
  bool _hidePassword = true;
  bool _hideConfirm = true;

  // Освобождение контроллеров
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Отправка формы
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    // Проверка всех полей
    if (!_formKey.currentState!.validate()) {
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: kError,
          content: Text('Please fix the errors in the form'),
        ),
      );
      return;
    }

    final user = UserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _role!,
      subscribed: _subscribe,
    );

    // Вывод данных в терминал
    debugPrint('========== NEW REGISTRATION ==========');
    debugPrint('Full name : ${user.fullName}');
    debugPrint('Email     : ${user.email}');
    debugPrint('Password  : ${'*' * _passwordController.text.length}');
    debugPrint('Role      : ${user.role.label}');
    debugPrint('Newsletter: ${user.subscribed}');
    debugPrint('Terms     : $_acceptedTerms');
    debugPrint('======================================');

    // SnackBar об успехе
    messenger.showSnackBar(
      const SnackBar(
        backgroundColor: kSuccess,
        content: Text('Account created successfully!'),
      ),
    );

    // Диалог об успехе
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded, color: kSuccess, size: 52),
        title: Text('Welcome, ${user.firstName}!'),
        content: Text(
          'Your ${user.role.label.toLowerCase()} account is ready.\n'
          '${user.email}',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Go to profile'),
          ),
        ],
      ),
    );

    // Переход в профиль
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Заголовок
                    const Icon(Icons.person_add_alt_1_rounded,
                        size: 48, color: kAccent),
                    const SizedBox(height: 16),
                    const Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: kPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Fill in the form to set up your profile.',
                      style: TextStyle(color: kTextSecondary),
                    ),
                    const SizedBox(height: 28),

                    // Поле «Full name»
                    TextFormField(
                      controller: _nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        hintText: 'Aruzhan Serikova',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: validateName,
                    ),
                    const SizedBox(height: 14),

                    // Поле «Email»
                    TextFormField(
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'name@narxoz.kz',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 14),

                    // Поле «Password»
                    TextFormField(
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        helperText: 'At least 6 characters',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        // Показать / скрыть пароль
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(_hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 14),

                    // Поле «Confirm password»
                    TextFormField(
                      controller: _confirmController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _hideConfirm,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        prefixIcon: const Icon(Icons.lock_reset_rounded),
                        // Показать / скрыть пароль
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                          icon: Icon(_hideConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Выбор роли (Dropdown)
                    DropdownButtonFormField<UserRole>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      items: [
                        for (final role in UserRole.values)
                          DropdownMenuItem(
                            value: role,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(role.icon, size: 20, color: kAccent),
                                const SizedBox(width: 10),
                                Text(role.label),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (role) => setState(() => _role = role),
                      validator: (role) =>
                          role == null ? 'Please select your role' : null,
                    ),
                    const SizedBox(height: 6),

                    // Рассылка (Switch)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _subscribe,
                      onChanged: (value) => setState(() => _subscribe = value),
                      title: const Text(
                        'Subscribe to newsletter',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Get news and updates by email'),
                    ),

                    // Согласие с условиями (Checkbox)
                    FormField<bool>(
                      initialValue: false,
                      validator: (value) => value == true
                          ? null
                          : 'You must accept the Terms and Conditions',
                      builder: (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _acceptedTerms,
                            activeColor: kAccent,
                            title: const Text(
                                'I accept the Terms and Conditions'),
                            onChanged: (value) {
                              setState(() => _acceptedTerms = value ?? false);
                              field.didChange(value);
                              field.validate();
                            },
                          ),
                          // Текст ошибки
                          if (field.hasError)
                            Text(
                              field.errorText!,
                              style: const TextStyle(
                                  color: kError, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Кнопка «Create account»
                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: kAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Create account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Экран профиля
class ProfileScreen extends StatelessWidget {
  final UserProfile user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  // Аватар
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: kAccent,
                    child: Text(
                      user.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Данные пользователя
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.mail_outline_rounded),
                          title: const Text('Email'),
                          subtitle: Text(user.email),
                        ),
                        ListTile(
                          leading: Icon(user.role.icon),
                          title: const Text('Role'),
                          subtitle: Text(user.role.label),
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications_none_rounded),
                          title: const Text('Newsletter'),
                          subtitle: Text(
                              user.subscribed ? 'Subscribed' : 'Not subscribed'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Кнопка «Log out»
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const RegistrationScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Log out'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
