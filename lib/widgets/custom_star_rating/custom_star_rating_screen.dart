import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';

class CustomStarRating extends StatefulWidget {
  final String initialRating;
  final double size;
  final Color? emptyColor;
  final Color? bgColor;
  final bool enable;
  final ValueChanged<double>? onRatingUpdate;

  const CustomStarRating({
    super.key,
    this.initialRating = "0.0",
    this.size = 22,
    this.emptyColor,
    this.bgColor,
    this.onRatingUpdate,
    this.enable = true,
  });

  @override
  State<CustomStarRating> createState() => _CustomStarRatingState();
}

class _CustomStarRatingState extends State<CustomStarRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = double.tryParse(widget.initialRating) ?? 0.0;
  }

  void _updateRating(double newRating) {
    setState(() {
      _rating = newRating;
    });
    if (widget.onRatingUpdate != null) {
      widget.onRatingUpdate!(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double starValue = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: GestureDetector(
            onTap: widget.enable ? () => _updateRating(starValue) : null,
            onDoubleTap: widget.enable ? () => _updateRating(starValue - 0.5) : null,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: _rating >= starValue - 0.5
                    ? AppThemeData.red01
                    : widget.bgColor ??
                    (themeChange.getThem()
                        ? AppThemeData.greyDark03
                        : AppThemeData.grey03),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                _rating >= starValue
                    ? Icons.star
                    : _rating >= starValue - 0.5
                    ? Icons.star_half
                    : Icons.star,
                color: widget.emptyColor ??
                    (_rating >= starValue - 0.5
                        ? AppThemeData.greyDark01
                        : themeChange.getThem()
                        ? AppThemeData.greyDark03
                        : AppThemeData.grey03),
                size: widget.size,
              ),
            ),
          ),
        );
      }),
    );
  }
}
