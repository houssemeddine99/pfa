import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget icon;


  CustomButton({
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double w ;
    double h ;
  if (MediaQuery.of(context).size.width <450 && MediaQuery.of(context).size.height < 550){
   w = MediaQuery.of(context).size.width * 0.42;
   h = MediaQuery.of(context).size.height * 0.27;
  }
    else if (MediaQuery.of(context).size.width <500){
   w = MediaQuery.of(context).size.width * 0.42;
   h = MediaQuery.of(context).size.height * 0.18;
  }
  else{
    w = MediaQuery.of(context).size.width * 0.42;
   h = MediaQuery.of(context).size.height * 0.3;
  }

    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF0F0F0),
             Color(0xFFF0F0F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button transparent
          elevation: 0, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconTheme(
              data: IconThemeData(color:Theme.of(context).colorScheme.onPrimary),
              child: icon,
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}