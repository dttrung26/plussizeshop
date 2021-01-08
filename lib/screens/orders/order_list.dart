import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../generated/l10n.dart';
import '../../models/index.dart';
import '../../models/order_list_model.dart';
import 'order_detail.dart';
import 'widgets/order_list_item.dart';
import 'widgets/order_list_loading_item.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userModel = Provider.of<UserModel>(context, listen: false);
    return ChangeNotifierProvider<OrderListModel>(
      create: (_) => OrderListModel(userModel),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            S.of(context).orderHistory,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          width: size.width,
          height: size.height,
          child: Consumer<OrderListModel>(
            builder: (context, model, _) {
              if (model.state == OrderListModelState.loading) {
                return ListView.builder(
                  itemBuilder: (context, index) => OrderListLoadingItem(),
                  itemCount: 5,
                );
              }
              return SmartRefresher(
                header: const MaterialClassicHeader(
                  backgroundColor: Colors.white,
                ),
                controller: model.refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: model.getMyOrder,
                onLoading: model.loadMore,
                child: ListView.builder(
                  itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetail(order: model.orders[index]),
                            ),
                          ),
                      child: OrderListItem(order: model.orders[index])),
                  itemCount: model.orders.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
