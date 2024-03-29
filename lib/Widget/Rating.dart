import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final double size;

  StarRating({this.starCount = 5, this.rating = .0, required this.onRatingChanged, required this.color,required this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: size,
        color: Colors.transparent,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}