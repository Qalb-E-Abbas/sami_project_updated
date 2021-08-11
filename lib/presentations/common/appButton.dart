import 'package:flutter/material.dart';


import 'dynamicFontSize.dart';
import 'package:sami_project/configurations/AppColors.dart';
class AppButton extends StatelessWidget {
  final String label;
  final String colorText;
  final VoidCallback onTap;

  const AppButton({Key key, this.label, this.colorText, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width / 1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: AppColors().colorFromHex(context, colorText)),
        child: Center(
          child: DynamicFontSize(
            label: label,
            fontSize: 20,
            color: AppColors.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
