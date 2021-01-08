import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../../common/constants/route_list.dart' show RouteList;
import '../../common/tools.dart' show Tools, kSize;
import '../../models/index.dart' show Blog;
import '../../routes/flux_navigate.dart';

class BlogListItem extends StatelessWidget {
  final List<Blog> posts;
  final int index;

  BlogListItem({this.posts, this.index});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return posts[index].id != null
        ? InkWell(
            onTap: () => FluxNavigate.pushNamed(
              RouteList.detailBlog,
              arguments: posts[index],
            ),
            child: Container(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: Tools.image(
                      url: posts[index].imageFeature,
                      width: screenWidth,
                      height: screenWidth * 0.5,
                      fit: BoxFit.fitWidth,
                      size: kSize.medium,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          posts[index].date ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(width: 20.0),
                        if (posts[index].author != null)
                          Text(
                            posts[index].author.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              height: 2,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    posts[index].title ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    posts[index].subTitle != null
                        ? parse(posts[index].subTitle).documentElement.text
                        : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Theme.of(context).accentColor.withOpacity(0.8),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          )
        : Container();
  }
}
