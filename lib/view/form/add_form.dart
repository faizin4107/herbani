import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddForm extends StatefulWidget {
  final List? list;
  final String? title;
  final state = _AddFormState();

  AddForm({
    Key? key,
    this.list,
    this.title,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AddFormState createState() => state;
}

class _AddFormState extends State<AddForm> {
  final List<dynamic> _list = [];
  Map object = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(31.0, 15, 31.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00B6F1), width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10.0.r))),
        height: (_list.length * 66) + 90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0.r),
                    topRight: Radius.circular(5.0.r)),
              ),
              leading: const Icon(Icons.verified_user),
              elevation: 2.5,
              title: Text(
                '${widget.title}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              backgroundColor: const Color(0xFF00B6F1),
              centerTitle: true,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Column(
                      children: const [
                        ListTile(
                          visualDensity: VisualDensity(vertical: -2),
                          dense: true,
                          title: Text(
                            'label',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'value',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
