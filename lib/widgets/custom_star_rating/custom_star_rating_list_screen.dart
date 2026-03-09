import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';

class CustomStarRatingList extends StatelessWidget {
  final String initialRating;
  final double size;
  final Color? emptyColor;
  final Color? bgColor;
  final bool enable;
  final ValueChanged<double>? onRatingUpdate;

  const CustomStarRatingList({
    super.key,
    this.initialRating = "0.0",
    this.size = 22,
    this.emptyColor,
    this.bgColor,
    this.onRatingUpdate,
    this.enable = true,
  });

  void _handleTap(double newRating) {
    if (onRatingUpdate != null) {
      onRatingUpdate!(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final double rating = double.tryParse(initialRating) ?? 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final double starValue = index + 1;
        final bool isActive = rating >= starValue - 0.5;
        final bool isFull = rating >= starValue;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: GestureDetector(
            onTap: enable ? () => _handleTap(starValue) : null,
            onDoubleTap: enable ? () => _handleTap(starValue - 0.5) : null,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: isActive
                    ? AppThemeData.red01
                    : bgColor ??
                        (themeChange.getThem()
                            ? AppThemeData.greyDark03
                            : AppThemeData.grey03),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                isFull
                    ? Icons.star
                    : isActive
                        ? Icons.star_half
                        : Icons.star,
                color: emptyColor ??
                    (isActive
                        ? AppThemeData.greyDark01
                        : themeChange.getThem()
                            ? AppThemeData.greyDark03
                            : AppThemeData.grey03),
                size: size,
              ),
            ),
          ),
        );
      }),
    );
  }
}
