import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<UserSetting>(context).exportData;
    var json = jsonEncode(data);
    var encoded = Uri.encodeComponent(json);
    Uri uri = Uri(
      scheme: Uri.base.scheme,
      port: Uri.base.port,
      host: Uri.base.host,
      pathSegments: Uri.base.pathSegments,
      queryParameters: <String, String>{
        'data': encoded,
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                decoration: TextDecoration.underline
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async => await launchUrl(uri),
                child: const Text('Export via url'),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: uri.toString()));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Url has been copied"),
                      ),
                    );
                  }
                },
                child: const Text('Copy url'),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Text(
            'Contact',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                decoration: TextDecoration.underline
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text('E-mail:'),
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: () async {
                  await Clipboard.setData(const ClipboardData(text: 'eugene.ws.low@gmail.com'));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("E-mail has been copied"),
                      ),
                    );
                  }
                },
                child: const Text('eugene.ws.low@gmail.com'),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Text(
            'Support',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              decoration: TextDecoration.underline
            ),
          ),
          const SizedBox(height: 8.0),
          TextButton(
            onPressed: () async {
              await launchUrl(Uri.parse('https://patreon.com/ProjectEugene'));
            },
            child: const Text('Patreon'),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
