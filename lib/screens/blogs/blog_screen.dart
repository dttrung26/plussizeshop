import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/general.dart';
import '../../generated/l10n.dart';
import '../../models/blog_model.dart';
import '../../widgets/blog/blog_list.dart';

class BlogScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !kIsWeb
          ? AppBar(
              elevation: 0.1,
              title: Text(
                S.of(context).blog,
                style: const TextStyle(color: Colors.white),
              ),
              leading: Center(
                child: GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: BlogList(blogs: Provider.of<BlogModel>(context, listen: false).blogs),
      ),
    );
  }
}
