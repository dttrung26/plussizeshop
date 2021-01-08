import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../common/constants/general.dart';
// import '../frameworks/shopify/services/shopify.dart';
import '../models/serializers/blog.dart';
import '../services/service_config.dart';
import 'serializers/blog.dart';

class BlogModel with ChangeNotifier {
  List<Blog> _blogs = [];

  List<Blog> get blogs => _blogs;

  void addBlogs(List<Blog> list) {
    _blogs = [...list];
    notifyListeners();
  }

  Future getBlogs() async {
    var blogData = [];
    switch (Config().type) {
      // get blogs for specific CMS type: strapi
      case "strapi":
        var _jsons = await Blog.getBlogsFromStrapi(url: Config().url);

        for (var item in _jsons) {
          blogData.add(Blog.fromStrapiJson(item));
        }
        _blogs = [...blogData];
        break;
      // case "shopify":
      //   final blogData = await ShopifyApi().fetchBlogShopifyLayout();
      //   _blogs = [...blogData];
      //   break;
      default:
        var _jsons = await Blog.getBlogs(
          url: Config().blog ?? Config().url,
          page: 1,
        );
        for (var item in _jsons) {
          blogData.add(Blog.fromJson(item));
        }
        _blogs = [...blogData];
    }
    notifyListeners();
  }
}

class Blog {
  dynamic id;
  String title;
  String subTitle;
  String date;
  String content;
  String author;
  String imageFeature;

  Blog.fromJson(Map<String, dynamic> json) {
    try {
      if (Config().isListingType()) {
        imageFeature = json['image_feature'];

        author = json['author_name'];
      } else {
        var imgJson = json["better_featured_image"];
        if (imgJson != null) {
          if (imgJson["media_details"]["sizes"]["medium_large"] != null) {
            imageFeature =
                imgJson["media_details"]["sizes"]["medium_large"]["source_url"];
          }
        }

        if (imageFeature == null) {
          var imgMedia = json['_embedded']['wp:featuredmedia'];
          if (imgMedia != null &&
              imgMedia[0]['media_details'] != null &&
              imgMedia[0]['media_details']["sizes"]["large"] != null) {
            imageFeature =
                imgMedia[0]['media_details']["sizes"]["large"]['source_url'];
          }
        }
        author = json["_embedded"]["author"] != null
            ? json["_embedded"]["author"][0]["name"]
            : '';
      }

      date = DateFormat.yMMMMd("en_US").format(DateTime.parse(json['date']));

      subTitle = HtmlUnescape().convert(json['excerpt']['rendered']);
      content = json['content']['rendered'];
      id = json['id'];
      title = HtmlUnescape().convert(json['title']['rendered']);
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
    }
  }

  Blog.fromShopifyJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      author = json["authorV2"]["name"];
      title = json['title'];
      content = json['content'];
      imageFeature = json["image"]["transformedSrc"];
      date = json["publishedAt"];
    } catch (e) {
      printLog(e.toString());
    }
  }

  Blog.fromStrapiJson(Map<String, dynamic> json) {
    try {
      SerializerBlog blog = SerializerBlog.fromJson(json);
      id = blog.id;
      title = blog.title;
      author = blog.user.displayName;
      content = blog.content;
      date = DateFormat.yMMMMd("en_US")
          .format(DateTime.parse(blog.date))
          .toString();
      dynamic images = [];
      if (blog.images != null) {
        for (var item in blog.images) {
          images.add(Config().url + item.url);
        }
      }
      imageFeature = images.isNotEmpty ? images[0] : "";
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Blog.empty(this.id)
      : title = '',
        subTitle = '',
        date = '',
        author = '',
        content = '',
        imageFeature = '';

  static Future<dynamic> getBlogs({url, categories, page = 1}) async {
    try {
      String param = '_embed&page=$page';
      if (categories != null) {
        param += '&categories=$categories';
      }
      final response = await http.get("$url/wp-json/wp/v2/posts?$param");
      if (response?.body?.isEmpty ?? true) {
        return [];
      }
      return jsonDecode(response.body);
    } on Exception catch (_) {
      return [];
    }
  }

  static Future<dynamic> getBlog({url, id}) async {
    final response = await http.get("$url/wp-json/wp/v2/posts/$id?_embed");
    return jsonDecode(response.body);
  }

  static Future<dynamic> getBlogsFromStrapi({url}) async {
    final response = await await http.get("$url/posts");
    return jsonDecode(response.body);
  }

  @override
  String toString() => 'Blog { id: $id  title: $title}';
}
