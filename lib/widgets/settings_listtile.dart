import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final String subtitle;

  final Color color;
  final IconData icon;


  const SettingsListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium
          ),
          subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall
          ),
          SizedBox(height: 4),
        ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 17),
         
        ),
        
      ],
    );


  }
}
