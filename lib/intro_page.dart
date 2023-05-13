// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:uuid/uuid.dart';

import 'custom_indicator_widget.dart';
import 'custom_text_field.dart';

class PageIntro {
  String id = const Uuid().v4();
  String introAssetImage;
  String title;
  String subTitle;
  bool displaysAction;
  PageIntro({
    required this.introAssetImage,
    required this.title,
    required this.subTitle,
    this.displaysAction = false,
  });
}

List<PageIntro> pageIntros = [
    PageIntro(
      introAssetImage: "page_1", 
      title: "Connect With\nCreators Easily", 
      subTitle: "Thank you for choosing us, we can save your lovely time."
    ),
    PageIntro(
      introAssetImage: "page_2", 
      title: "Get Inspiration\nFrom Creators", 
      subTitle: "Find your favourite creator and get inspired by them."
    ),
    PageIntro(
      introAssetImage: "page_3", 
      title: "Let's\nGet Started", 
      subTitle: "To register for an account, kindly enter your details.",
      displaysAction: true
    )
  ];
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideFromTop;
  late Animation<Offset> _slideFromBottom;
  late Animation<double> _opacityAnimation;
  late AnimationController _wholeViewAnimationController;
  late Animation<Offset> _hideWholeViewAnimation;
  late Animation<double> _hideWholeViewOpacityAnimation;
  late SpringSimulation springSimulation;
  late SpringSimulation wholeViewSpringSimulation;
  var pageIntro = pageIntros[0];

  @override
  void initState() {
    super.initState();

    //Top container animation.
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 1)
    );

    _slideFromTop = Tween<Offset>(
      begin: const Offset(0.0, -1.0), 
      end: Offset.zero
    )
    .animate(_controller);

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _slideFromBottom = Tween<Offset>(
      begin: const Offset(0.0, 1.0), 
      end: Offset.zero
    )
    .animate(_controller);

      springSimulation = SpringSimulation(
        const SpringDescription(
          mass: 30,
          stiffness: 5,
          damping: 0.75,
        ),
        0, // starting point
        1, // ending point
        0, // velocity
      );

       wholeViewSpringSimulation = SpringSimulation(
        const SpringDescription(
          mass: 20,
          stiffness: 5,
          damping: 0.75,
        ),
        0, // starting point
        1, // ending point
        0, // velocity
      );

    _controller.animateWith(springSimulation);

    _wholeViewAnimationController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 1)
    );

    _hideWholeViewAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), 
      end: const Offset(0.0, 1)
    )
    .animate(_wholeViewAnimationController);

    _hideWholeViewOpacityAnimation = Tween<double>(
      begin: 1, 
      end: 0
    )
    .animate(_wholeViewAnimationController);

  }

  double getVisibleScreenHeight(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return mediaQueryData.size.height - mediaQueryData.padding.top - mediaQueryData.padding.bottom;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _controllerTop..reset()..forward();
    return SafeArea(
      child: SlideTransition(
        position: _hideWholeViewAnimation,
        child: FadeTransition(
          opacity: _hideWholeViewOpacityAnimation,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                    children: [
                      SizedBox(
                        height: getVisibleScreenHeight(context) * 0.5,
                        child: Stack(
                          children: [
                            FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideFromTop,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      'assets/images/${pageIntro.introAssetImage}.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (pageIntro != pageIntros.first)
                              IconButton(
                                padding: const EdgeInsets.all(5),
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.chevron_left),
                                iconSize: 35,
                                onPressed: () {
                                    updatePageIntro(isPrevious: true);
                                }
                              ),
                          ],
                        ),
                      ),
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideFromBottom,
                          child: BottomWidget(
                            intro: pageIntro, 
                            nextPressed: () {
                               updatePageIntro();
                            }
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }

  updatePageIntro({bool isPrevious = false}) {
    _wholeViewAnimationController.animateWith(wholeViewSpringSimulation);
    Future.delayed(const Duration(milliseconds: 600), () {
      final currentPageIndex = pageIntros.indexOf(pageIntro);
      //Page intro object not founc
      if (currentPageIndex == -1) {
        setState(() {
          pageIntro = pageIntros[0];
        });
      }
      if (isPrevious && currentPageIndex != 0) {
        setState(() {
          pageIntro = pageIntros[currentPageIndex - 1];
        });
      } else if(!isPrevious && currentPageIndex != pageIntros.length - 1) {
        setState(() {
          pageIntro = pageIntros[currentPageIndex + 1];
        });
      } else {
        setState(() {
          pageIntro = pageIntros[0];
        });
      }
      _wholeViewAnimationController.reset();
      _controller..reset()..animateWith(springSimulation);
    });
  }
}

class BottomWidget extends StatelessWidget {
  final PageIntro intro;
  final VoidCallback nextPressed;

  const BottomWidget({super.key, required this.intro, required this.nextPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(intro.title, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text(intro.subTitle, style: const TextStyle(fontSize: 20)),
        !intro.displaysAction ? nextAction() : const Login()
    ]);
  }

  Widget nextAction() {
    return Column(children: [
      const SizedBox(height: 60),
      CustomIndicator(
        totalPages: pageIntros.where((element) => !element.displaysAction).length, 
        currentPage: pageIntros.indexOf(intro) 
      ),
      const SizedBox(height: 60),
      Center(child: button(title: "Next", widthFactor: 0.4, onPressed: () {
        nextPressed();
      }))
    ]); 
  }
}

class Login extends StatelessWidget {
  final _email = "";
  final _password = "";
  
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
  children: [
    CustomTextField(
    text: _email,
    hint: "Email Address",
    leadingIcon: const Icon(Icons.email), 
    onChanged: (String value) {  },
    ),
    CustomTextField(
    text: _password,
    hint: "Password",
    leadingIcon: const Icon(Icons.lock),
    isPassword: true, 
    onChanged: (String value) {  },
    ),
    const SizedBox(height: 10),
    button(title: "Continue", widthFactor: 1, onPressed: () {})
  ],
);
  }
}


  Widget button({required String title, required double widthFactor, required VoidCallback onPressed}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          child: Container(
            width: constraints.maxWidth * widthFactor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ),
      );
    }
  );
  }