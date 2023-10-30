import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:talkios/core/constant/revenuecat_constants.dart';
import 'package:talkios/core/view/base/base_state.dart';

import '../core/config/revenuecat/singletons_data.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends BaseState<Paywall> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 70.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: color.dark100,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25.0))),
              child: Center(
                  child: Text(
                '✨ Talkios AI Premium',
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.background,
                  fontSize: 18.0,
                  fontFamily: font.semiBold,
                ),
              )),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'TALKIOS AI PREMIUM',
                ),
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Colors.white,
                  child: ListTile(
                      onTap: () async {
                        try {
                          CustomerInfo customerInfo =
                              await Purchases.purchasePackage(
                                  myProductList[index]);
                          EntitlementInfo? entitlement =
                              customerInfo.entitlements.all[entitlementId];
                          appData.entitlementIsActive =
                              entitlement?.isActive ?? false;
                        } catch (e) {
                          print(e);
                        }

                        setState(() {});
                        Navigator.pop(context);
                      },
                      title: Text(
                        myProductList[index].storeProduct.title,
                      ),
                      subtitle: Text(
                        myProductList[index].storeProduct.description,
                      ),
                      trailing: Text(
                        myProductList[index].storeProduct.priceString,
                      )),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "footerText",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
