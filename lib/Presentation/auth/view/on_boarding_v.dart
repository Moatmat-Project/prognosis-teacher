import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _controller = PageController();
  int slidesLenght = 7;
  bool lastPage = false;
  List<Color> textColors = [
    ColorsResources.blueText,
    ColorsResources.orangeText,
    ColorsResources.greenText,
    ColorsResources.redText,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  lastPage = value == slidesLenght - 1;
                });
              },
              children: [
                PageSlide(
                  color: textColors[0],
                  customPadding: const EdgeInsets.all(75),
                  content: Image.asset("assets/images/boarding/1.png"),
                  text: "احدث الوسائل التعليمية في متناول يديك ..",
                ),
                PageSlide(
                  color: textColors[1],
                  content: Image.asset("assets/images/boarding/2.png"),
                  text: "أنشئ الاختبارات المؤتمتة بكل بساطة وسهولة",
                ),
                PageSlide(
                  color: textColors[2],
                  content: Image.asset("assets/images/boarding/3.png"),
                  text: "حدد قواعدك الخاصة لكل اختبار \n خصص معايير متنوعة متدرجة الصعوبة لتزيد خبرة ومهارة طلابك",
                ),
                PageSlide(
                  color: textColors[3],
                  content: Image.asset("assets/images/boarding/4.png"),
                  text: "إحصل على نتيجة الاختبار من الطالب بمجرد حله واستعرض النتائج بمختلف لإحصائيات والطرق",
                ),
                PageSlide(
                  color: textColors[0],
                  content: Image.asset("assets/images/boarding/5.png"),
                  text: "صنف طلابك ضمن مجموعات وارسل لهم ما تريد من اختبارات او تصفح نتائجهم سويةً",
                ),
                PageSlide(
                  color: textColors[1],
                  content: Image.asset("assets/images/boarding/6.png"),
                  text: "امتلك أرشيفك الخاص لكل اسئلتك ، تحكم بكل شيئ واحتفظ بهم ك ملف ان اردت",
                ),
                PageSlide(
                  color: textColors[2],
                  customPadding: const EdgeInsets.all(75),
                  content: Image.asset("assets/images/boarding/7.png"),
                  text: "تواصل مباشرةً مع فريق دعم جاهز و مدرب لمساعدتك بأسرع وأفضل شكل",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: SizesResources.s8,
              left: SizesResources.s8,
              right: SizesResources.s8,
            ),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: slidesLenght,
                    effect: const WormEffect(
                      dotColor: ColorsResources.borders,
                      activeDotColor: ColorsResources.darkPrimary,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: ColorsResources.primary,
                    child: IconButton(
                      icon: const Icon(
                        Icons.navigate_next,
                        color: ColorsResources.whiteText1,
                      ),
                      onPressed: () {
                        if (lastPage) {
                          onFinish();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.decelerate,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: SizesResources.s10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onFinish() {
    context.read<AuthCubit>().startAuth();
  }
}

class PageSlide extends StatelessWidget {
  const PageSlide({
    super.key,
    required this.text,
    required this.content,
    required this.color,
    this.customPadding,
  });
  final String text;
  final Widget content;
  final Color color;
  final EdgeInsets? customPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: SizesResources.s10 * 2),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: customPadding ?? const EdgeInsets.all(0),
                child: content,
              ),
            ),
          ),
          const SizedBox(height: SizesResources.s10 * 2),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SizesResources.s3,
              horizontal: SizesResources.s3,
            ),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: FontsResources.regularStyle().copyWith(
                height: 1.2,
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
