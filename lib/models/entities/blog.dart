import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../common/constants/general.dart';

class Blog {
  int id;
  String title;
  String subTitle;
  String date;
  String content;
  String author;
  String imageFeature;

  Blog.fromJson(Map<String, dynamic> json) {
    try {
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
            imgMedia[0]['media_details']["sizes"]["large"] != null) {
          imageFeature =
              imgMedia[0]['media_details']["sizes"]["large"]['source_url'];
        }
      }

      author = json["_embedded"]["author"] != null
          ? json["_embedded"]["author"][0]["name"]
          : '';

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

  Blog.empty(this.id)
      : title = '',
        subTitle = '',
        date = '',
        author = '',
        content = '',
        imageFeature = '';

  static Future<dynamic> getBlogs({url, categories, page = 1}) async {
    String param = '_embed&page=$page';
    if (categories != null) {
      param += '&categories=$categories';
    }
    final response = await http.get("$url/wp-json/wp/v2/posts?$param");
    return jsonDecode(response.body);
  }

  static Future<dynamic> getBlog({url, id}) async {
    final response = await http.get("$url/wp-json/wp/v2/posts/$id?_embed");
    return jsonDecode(response.body);
  }

  @override
  String toString() => 'Blog { id: $id  title: $title}';
}
