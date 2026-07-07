import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/auth_viewmodel.dart';
import 'login_page.dart';
import 'register_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AuthViewModel>().loadSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileCard(context, auth),

            const SizedBox(height: 18),

            _buildPersonalInformation(auth),

            const SizedBox(height: 18),

            _buildMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AuthViewModel auth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: const LinearGradient(
          colors: [Color(0xff3478F6), Color(0xff1D4ED8)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white.withOpacity(.25),

            child: const Icon(Icons.person, color: Colors.white, size: 44),
          ),

          const SizedBox(height: 18),

          Text(
            auth.isLoggedIn ? auth.currentUser?.username ?? "-" : "Guest",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            auth.isLoggedIn
                ? auth.currentUser?.email ?? "-"
                : "You are not logged in",
            style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 15),
          ),

          const SizedBox(height: 24),

          auth.isLoggedIn
              ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await auth.logout();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,

                      elevation: 0,

                      minimumSize: const Size.fromHeight(48),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      "Logout",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );

                          if (context.mounted) {
                            context.read<AuthViewModel>().loadSession();
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff2563EB),

                          elevation: 0,

                          minimumSize: const Size.fromHeight(48),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );

                          if (context.mounted) {
                            context.read<AuthViewModel>().loadSession();
                          }
                        },

                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,

                          side: const BorderSide(color: Colors.white),

                          minimumSize: const Size.fromHeight(48),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: const Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation(AuthViewModel auth) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "PERSONAL INFORMATION",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 18),

            _infoTile("Full Name", auth.currentUser?.username ?? "-"),

            const Divider(),

            _infoTile("Email", auth.currentUser?.email ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(height: 0),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
