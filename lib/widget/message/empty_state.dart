import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herbani/helper/textstyle_custom.dart';

class EmptyState extends StatelessWidget {
  final String? title, message;
  const EmptyState({Key? key, this.title, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 16,
      color: Theme.of(context).cardColor.withOpacity(.95),
      shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$title',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textStyleNormal(context),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$message',
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: textStyleNormal(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataNotFound extends StatelessWidget {
  final String? message;
  const DataNotFound({Key? key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline_rounded),
        Align(
            alignment: Alignment.center,
            child: Text(message.toString(),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: textStyleNormal(context))),
      ],
    );
  }
}

class FailedRequest extends StatelessWidget {
  final String? message;
  const FailedRequest({Key? key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.info,
          size: 30.sp,
          color: Colors.red,
        ),
        Text(message.toString(),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textStyleNormal(context)),
      ],
    );
  }
}
