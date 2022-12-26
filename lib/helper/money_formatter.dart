import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herbani/helper/textstyle_custom.dart';

class MoneyFormatter extends StatelessWidget {
  final String? money, typeStyle;
  final Color? colorVal;

  const MoneyFormatter({Key? key, this.money, this.typeStyle, this.colorVal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
      symbol: 'Rp',
      symbolSide: SymbolSide.left,
      thousandSeparator: '.',
      decimalSeparator: ',',
    );
    CurrencyFormatter cf = CurrencyFormatter();
    if (money == '' || money == null || money == 'null') {
      return Text(
        '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: typeStyle == 'bold'
            ? textStyleCustom(context, colorVal, 12.sp, FontWeight.bold)
            : textStyleCustom(context, colorVal, 12.sp, FontWeight.normal),
      );
    } else {
      return Text(
        cf.format(money, euroSettings),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: typeStyle == 'bold'
            ? textStyleCustom(context, colorVal, 12.sp, FontWeight.bold)
            : textStyleCustom(context, colorVal, 12.sp, FontWeight.normal),
      );
    }
  }
}
