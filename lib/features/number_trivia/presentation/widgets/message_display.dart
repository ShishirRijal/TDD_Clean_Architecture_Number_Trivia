import 'package:flutter/material.dart';

import '../../../../main.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final bool isLoading;
  final bool isEmpty;
  final int? number;
  const MessageDisplay({
    Key? key,
    required this.message,
    this.isLoading = false,
    this.isEmpty = false,
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: greenColor)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (number != null)
                    Text(
                      number.toString(),
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(message,
                            style: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
