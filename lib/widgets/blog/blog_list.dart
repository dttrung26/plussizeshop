import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/constants.dart';
import '../../models/index.dart' show Blog;
import '../../services/service_config.dart';
import 'blog_list_item.dart';

class BlogList extends StatefulWidget {
  final List<Blog> blogs;

  BlogList({this.blogs});

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  RefreshController _refreshController;
  int _page = 1;
  bool _isEnd = false;
  final double _padding = 2.0;
  List<Blog> _blogList = [];

  List<Blog> emptyList = [
    Blog.empty(1),
    Blog.empty(2),
    Blog.empty(3),
    Blog.empty(4),
    Blog.empty(5),
    Blog.empty(6)
  ];

  @override
  initState() {
    super.initState();
    _refreshController = RefreshController(
        initialRefresh: widget.blogs == null || widget.blogs.isEmpty);

    _blogList =
        widget.blogs == null || widget.blogs.isEmpty ? emptyList : widget.blogs;
  }

  Future<List<Blog>> _getBlogs({page}) async {
    try {
      List<Blog> blogs = [];
      var _jsons =
          await Blog.getBlogs(url: Config().blog ?? Config().url, page: page);
      for (var item in _jsons) {
        blogs.add(Blog.fromJson(item));
      }
      return blogs;
    } catch (e) {
      return [];
    }
  }

  _onRefresh() async {
    var blogs = await _getBlogs(page: 1);
    setState(() {
      _blogList = blogs;
      _page = 1;
      _isEnd = false;
    });
    _refreshController.refreshCompleted();
  }

  _onLoading() async {
    if (!_isEnd) {
      List<Blog> newBlogs = await _getBlogs(page: _page + 1);
      if (newBlogs.isEmpty) {
        setState(() {
          _isEnd = true;
        });
      } else {
        setState(() {
          _page = _page + 1;
          _blogList = [..._blogList, ...newBlogs];
        });
      }
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: const ClassicHeader(),
      enablePullDown: true,
      enablePullUp: !_isEnd,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      footer: kCustomFooter(context),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: Column(
          children: List.generate(
            _blogList.length,
            (index) {
              return BlogListItem(posts: _blogList, index: index);
            },
          ),
        ),
      ),
    );
  }
}
