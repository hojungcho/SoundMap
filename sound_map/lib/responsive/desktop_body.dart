import 'package:flutter/material.dart';
import 'package:sound_map/UI/first_ui.dart';
import 'package:sound_map/UI/second_ui.dart';

class DesktopBody extends StatefulWidget {
  const DesktopBody({super.key});

  @override
  _DesktopBodyState createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<DesktopBody> {
  bool _isFirstUI = true; // 상태 변수
  final TextEditingController _controller = TextEditingController();

  void _toggleUI() {
    setState(() {
      _isFirstUI = !_isFirstUI; // 상태 값 변경
    });
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),

            // sound map & searchbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    // darker shadow on bottom right
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 15,
                      offset: const Offset(4, 4),
                    ),

                    // lighter shadow on top left
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 15,
                      offset: const Offset(-2, -2),
                    ),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            _isFirstUI = true; // reset
                            _controller.clear(); // clear text field
                          });
                        },
                        child: Text(
                            "Sound Map",
                          style: TextStyle(
                            fontSize: 70.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Youtube URL text field
                      SizedBox(
                        width: 550,
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isFirstUI = false;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.grey),
                                  child: const Text(
                                    'Generate',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Paste a YouTube song link.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _isFirstUI ?
            FirstUi() : SecondUi(yt_url: _controller.text)
          ],
        ),
      ),
    );
  }
}