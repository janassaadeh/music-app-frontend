import 'package:flutter/material.dart';
import 'package:music_app/models/user.dart';
import 'package:music_app/pages/auth/landing_page.dart';
import 'package:music_app/pages/profile_page.dart';
import 'package:music_app/provider/users_provider.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/services/user_service.dart';
import 'package:music_app/utils/shorcuts.dart';
import 'package:music_app/widgets/custom_divider.dart';
import 'package:music_app/widgets/layout/app_bar.dart';
import 'package:music_app/widgets/settings_listtile.dart';
import 'package:provider/provider.dart';
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final usersProvider = context.watch<UsersProvider>();
    
    return Scaffold(
      appBar: CustomAppBar(title: "Settings", onBackTap: () => pop(context)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => push(context, ProfilePage()),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child:CircleAvatar(
                          radius: 65,
                            backgroundColor: Colors.grey.shade200,
            backgroundImage: NetworkImage("https://tse2.mm.bing.net/th/id/OIP.CIn8fInVEpY4ti24C9LfWgHaFJ?pid=Api&h=220&P=0"),
                        )
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${usersProvider.currentUser?.firstName ?? "Guest"} ${usersProvider.currentUser?.lastName ?? "Guest"}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${usersProvider.followers.length}', 
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                                color: Color.fromARGB(255, 72, 71, 71),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 12.0, right: 16, left: 8),
                        child: Container(
                          color: Colors.grey,
                          width: 1,
                          height: 20,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usersProvider.following.length.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Following',
                            style: TextStyle(
                                color: Color.fromARGB(255, 72, 71, 71),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 50),
          Column(
            children: [
              SettingsListTile(
                  title: "Email Address",
                  subtitle: usersProvider.currentUser?.email ?? "Add your email address",
                  color: Colors.pink,
                  icon: Icons.email_outlined),
              CustomDivider(),
              SettingsListTile(
                  title: "Your account",
                  subtitle: "Your personal info",
                  color: Colors.deepPurple,
                  icon: Icons.account_circle_outlined),
              CustomDivider(),
              
              SettingsListTile(
                  title: "Change Theme",
                  subtitle: "Set to Dark or Light mode",
                  color: Colors.red,
                  icon: Icons.settings),
              CustomDivider(),
              SettingsListTile(
                  title: "Explore Gold Rewards",
                  subtitle: "Upgrade to premium",
                  color: Colors.amber,
                  icon: Icons.star),
              CustomDivider(),
              SettingsListTile(
                  title: "Notifications",
                  subtitle: "Push notifications settings",
                  color: Colors.blue,
                  icon: Icons.notifications),
              CustomDivider(),
              GestureDetector(
                  onTap: () {
                    AuthenticationService().logout();
                    pushReplace(context, LandingPage());
                  },
                  child: SettingsListTile(
                      title: "Logout",
                      subtitle: "Sign out of your account",
                      color: Colors.blue,
                      icon: Icons.logout)),
            ],
          ),
        ],
      ),
    );
  }
}
