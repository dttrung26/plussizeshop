import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/tools.dart';
import '../../generated/l10n.dart' show S;
import '../../models/index.dart'
    show AddonsOption, AppModel, Product, ProductAddons;
import '../../services/index.dart';

mixin ProductAddonsMixin {
  Future<void> getProductAddons({
    BuildContext context,
    Product product,
    Function(
            {Product productInfo,
            Map<String, Map<String, AddonsOption>> selectedOptions})
        onLoad,
    Map<String, Map<String, AddonsOption>> selectedOptions,
  }) async {
    final lang = Provider.of<AppModel>(context, listen: false).langCode;
    await Services().getProduct(product.id, lang: lang).then((onValue) async {
      if (onValue?.addOns?.isNotEmpty ?? false) {
        /// Select default options.
        selectedOptions.addAll(onValue.defaultAddonsOptions);

        onLoad(productInfo: onValue, selectedOptions: selectedOptions);
      }
    });
    return null;
  }

  List<Widget> getProductAddonsWidget({
    BuildContext context,
    String lang,
    Product product,
    Map<String, Map<String, AddonsOption>> selectedOptions,
    Function onSelectProductAddons,
  }) {
    final rates = Provider.of<AppModel>(context).currencyRate;
    final List<Widget> listWidget = [];
    if (product.addOns?.isNotEmpty ?? false) {
      listWidget.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight.withOpacity(0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).options.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  S.of(context).total,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                Tools.getCurrencyFormatted(product.productOptionsPrice, rates),
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      );
      listWidget.add(ExpansionPanelList.radio(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        initialOpenPanelValue: 0,
        children: product.addOns.map<ExpansionPanelRadio>((ProductAddons item) {
          final Map<String, AddonsOption> selected =
              (selectedOptions[item.name] ?? {});
          return ExpansionPanelRadio(
            canTapOnHeader: true,
            value: item.name,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                visualDensity: VisualDensity.compact,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        item.name,
                      ),
                    ),
                    (item.isRadioButtonType && item.required)
                        ? Text(
                            S.of(context).mustSelectOneItem,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                        : const Text('')
                  ],
                ),
                subtitle: selected.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          item.isTextAreaType
                              ? (selected[item.name]?.label ?? '')
                              : selected.keys
                                  .toString()
                                  .replaceAll('(', '')
                                  .replaceAll(')', ''),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      )
                    : Container(),
                contentPadding: EdgeInsets.zero,
              );
            },
            body: Wrap(
              children: List.generate(item.options.length, (index) {
                final AddonsOption option = item.options[index];
                final bool isSelected = selected[option.label] != null;
                final onTap = () {
                  if (item.isRadioButtonType) {
                    selected.clear();
                    selected[option.label] = option;
                    onSelectProductAddons(selectedOptions: selectedOptions);
                    return;
                  }
                  if (item.isCheckboxType) {
                    if (isSelected) {
                      selected.remove(option.label);
                    } else {
                      selected[option.label] = option;
                    }
                    onSelectProductAddons(selectedOptions: selectedOptions);
                    return;
                  }
                };
                return Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.45,
                  ),
                  child: InkWell(
                    onTap: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.isRadioButtonType)
                          Radio(
                            visualDensity: VisualDensity.compact,
                            groupValue: selected.keys.isNotEmpty
                                ? selected.keys.first
                                : '',
                            value: option.label,
                            onChanged: (_) => onTap(),
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        if (item.isCheckboxType)
                          Checkbox(
                            visualDensity: VisualDensity.compact,
                            onChanged: (_) => onTap(),
                            activeColor: Theme.of(context).primaryColor,
                            checkColor: Colors.white,
                            value: isSelected,
                          ),
                        if (item.isTextAreaType)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextField(
                                onChanged: (text) {
                                  if (text.isEmpty) {
                                    selected.remove(item.name);
                                    onSelectProductAddons(
                                        selectedOptions: selectedOptions);
                                    return;
                                  }

                                  if (selected[item.name] != null) {
                                    selected[item.name].label = text;
                                  } else {
                                    selected[item.name] = AddonsOption(
                                      parent: item.name,
                                      label: text,
                                    );
                                  }
                                  onSelectProductAddons(
                                      selectedOptions: selectedOptions);
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: option.label,
                                ),
                                minLines: 1,
                                maxLines: 4,
                              ),
                            ),
                          ),
                        if (!item.isTextAreaType)
                          Text(
                            option.label,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : null,
                              fontSize: 14,
                            ),
                          ),
                        if (!item.isTextAreaType)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              '(${Tools.getCurrencyFormatted(option.price, rates)})',
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : null,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        }).toList(),
      ));
    }
    return listWidget;
  }
}
