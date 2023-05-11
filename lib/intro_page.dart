// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:uuid/uuid.dart';

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
            child: Column(
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideFromTop,
                      child: Container(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'assets/images/${pageIntro.introAssetImage}.png',
                          ),
                        ),
                        ),
                    ),
                  ),
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideFromBottom,
                      child: BottomWidget(
                        intro: pageIntro, 
                        nextPressed: () {
                          _wholeViewAnimationController.animateWith(wholeViewSpringSimulation);
                          Future.delayed(const Duration(milliseconds: 600), () {
                              updatePageIntro();
                             _wholeViewAnimationController.reset();
                            _controller..reset()..animateWith(springSimulation);
                          });
                        }
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updatePageIntro({bool isPrevious = false}) {
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
  }
}

class BottomWidget extends StatelessWidget {
  final PageIntro intro;
  final VoidCallback nextPressed;

  const BottomWidget({super.key, required this.intro, required this.nextPressed});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(intro.title, style: const TextStyle(fontSize: 40), textAlign: TextAlign.center),
      const SizedBox(height: 15),
      Text(intro.subTitle, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
      TextButton(
        onPressed: nextPressed, 
        child: const Text("Next")
      ) 
    ]);
  }
}