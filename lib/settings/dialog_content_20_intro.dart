import 'package:flutter/material.dart';

import '../generated/i18n.dart';

class DialogContent extends StatefulWidget {

  final Function onClosed;

  DialogContent({this.onClosed});

  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<DialogContent> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Material(
        type: MaterialType.transparency, //设置透明的效果
        child: Center(
          // 让子控件显示到中间
          child: SizedBox(
            //比较常用的一个控件，设置具体尺寸
            width: 280,
            height: 430,
            child: Container(
              padding:
                  EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Container(
                        height: 27,
                        width: 27,
                        padding: EdgeInsets.all(7),
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 13,
                        ),
                      ),
                      onTap: () => _handleClose(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '20/20/20',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xDD000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      //'Please take a break to look into the distance for 20 seconds at something 20 yards(18 meters) away',
                      S.of(context).settings_202020_msg,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0x89000000),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Image.asset('images/img_20_20_20.png'),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleClose() {
    widget.onClosed();
    Navigator.of(context).pop();
  }
}
