import 'package:flutter/material.dart';
import 'package:jpuzzle/common/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required double dimensions,
    required this.text,
    required this.icon,
    this.onTap,
  })  : _dimensions = dimensions,
        super(key: key);

  final double _dimensions;
  final VoidCallback? onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: kPrimaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 5.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: kBackgroundColor,
          ),
          title: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kAccentColor,
            ),
          ),
        ),
      ),
    );
  }
}
