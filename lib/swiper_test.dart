import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperTest extends StatefulWidget {
  const SwiperTest({Key? key}) : super(key: key);

  @override
  State<SwiperTest> createState() => _SwiperTestState();
}

class _SwiperTestState extends State<SwiperTest> {
  final List<String> imgList = ['image/cat.jpg', 'image/cat2.jpg', 'image/cat3.jpg'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white10,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Hero(
            tag: 'image',
            child: Swiper(
              autoplay: true,
              scale: 0.9,
              viewportFraction: 0.8,
              control: const SwiperControl(
                color: Colors.white10,
              ) ,
              pagination: const SwiperPagination(
                  alignment: Alignment.bottomRight,
                  builder: DotSwiperPaginationBuilder(
                      color: Colors.white,
                      activeColor: Colors.white10
                  )
              ),
              itemCount: imgList.length,
              itemBuilder: (BuildContext context, int index){
                return Image.asset(
                  imgList[index],
                  fit: BoxFit.fitHeight,
                );
              },
            ),
          )
        ),
      ),
    );
  }
}
