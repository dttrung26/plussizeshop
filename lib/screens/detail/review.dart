import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Review, UserModel;
import '../../services/index.dart';
import '../../widgets/common/start_rating.dart';

class Reviews extends StatefulWidget {
  final String productId;

  Reviews(this.productId);

  @override
  _StateReviews createState() => _StateReviews(productId);
}

class _StateReviews extends State<Reviews> {
  final services = Services();
  double rating = 0.0;
  final comment = TextEditingController();
  List<Review> reviews;
  final String productId;

  _StateReviews(this.productId);

  @override
  void initState() {
    super.initState();
    getListReviews();
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  void updateRating(double index) {
    setState(() {
      rating = index;
    });
  }

  void sendReview() {
    if (rating == 0.0) {
      Tools.showSnackBar(Scaffold.of(context), S.of(context).ratingFirst);
      return;
    }
    if (comment.text == null || comment.text.isEmpty) {
      Tools.showSnackBar(Scaffold.of(context), S.of(context).commentFirst);
      return;
    }
    final user = Provider.of<UserModel>(context, listen: false);
    services.createReview(productId: productId, data: {
      "review": comment.text,
      "reviewer": user.user.name,
      "reviewer_email": user.user.email,
      "rating": rating,
      "status":
          kAdvanceConfig["EnableApprovedReview"] == true ? "approved" : "hold"
    }).then((onValue) {
      getListReviews();
      setState(() {
        rating = 0.0;
        comment.text = "";
      });
    });
  }

  void getListReviews() {
    services.getReviews(productId).then((onValue) {
      setState(() {
        reviews = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Provider.of<UserModel>(context).loggedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        reviews == null
            ? Container(height: 80, child: kLoadingWidget(context))
            : (reviews.isEmpty
                ? Container(
                    height: 80,
                    child: Center(
                      child: Text(S.of(context).noReviews),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      for (var i = 0; i < reviews.length; i++)
                        renderItem(context, reviews[i])
                    ],
                  )),
        const SizedBox(height: 20),
        if (isLoggedIn)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  S.of(context).productRating,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              if (kAdvanceConfig['EnableRating'])
                Flexible(
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SmoothStarRating(
                        label: const Text(''),
                        allowHalfRating: true,
                        onRatingChanged: updateRating,
                        starCount: 5,
                        rating: rating,
                        size: 28.0,
                        color: Theme.of(context).primaryColor,
                        borderColor: Theme.of(context).primaryColor,
                        spacing: 0.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        if (isLoggedIn)
          Container(
            margin: const EdgeInsets.only(bottom: 40, top: 15.0),
            padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 5.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: comment,
                    maxLines: 3,
                    minLines: 1,
                    decoration:
                        InputDecoration(labelText: S.of(context).writeComment),
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onTap: sendReview,
                )
              ],
            ),
          )
      ],
    );
  }

  Widget renderItem(context, Review review) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(2.0)),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (kAdvanceConfig['EnableRating'])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(review.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  SmoothStarRating(
                      label: const Text(''),
                      allowHalfRating: true,
                      starCount: 5,
                      rating: review.rating,
                      size: 12.0,
                      color: theme.primaryColor,
                      borderColor: theme.primaryColor,
                      spacing: 0.0),
                ],
              ),
            const SizedBox(height: 10),
            Text(review.review,
                style: const TextStyle(color: kGrey600, fontSize: 14)),
            const SizedBox(height: 12),
            Text(timeago.format(review.createdAt),
                style: const TextStyle(color: kGrey400, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
