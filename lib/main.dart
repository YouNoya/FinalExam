import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '나만의 독특한 자기소개 페이지',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final FocusNode _focusNode = FocusNode();
  bool _isFront = true;

  void _onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  void _nextPage() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _previousPage() {
    _pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _flipCard() {
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이윤호의 페이지'),
      ),
      drawer: AppDrawer(_pageController),
      body: Stack(
        children: [
          RawKeyboardListener(
            focusNode: _focusNode,
            onKey: _onKeyEvent,
            autofocus: true,
            child: PageView(
              controller: _pageController,
              children: [
                FlippingCardPage(
                  onFlip: _flipCard,
                  isFront: _isFront,
                ),
                IntroductionPage(),
                HobbiesPage(),
                MBTIPage(),
                CareerPage(),
                GameCompanyPage(),
                ContactPage(),
              ],
            ),
          ),
          if (!_isFront)
            Positioned(
              left: 16,
              top: MediaQuery.of(context).size.height / 2 - 25,
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 50),
                onPressed: _previousPage,
              ),
            ),
          if (!_isFront)
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height / 2 - 25,
              child: IconButton(
                icon: Icon(Icons.arrow_right, size: 50),
                onPressed: _nextPage,
              ),
            ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final PageController pageController;

  AppDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '메뉴',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('소개'),
            onTap: () {
              Navigator.pop(context);
              pageController.jumpToPage(1);
            },
          ),
          ListTile(
            title: Text('취미'),
            onTap: () {
              Navigator.pop(context);
              pageController.jumpToPage(2);
            },
          ),
          ListTile(
            title: Text('MBTI'),
            onTap: () {
              Navigator.pop(context);
              pageController.jumpToPage(3);
            },
          ),
          ListTile(
            title: Text('진로분야'),
            onTap: () {
              Navigator.pop(context);
              pageController.jumpToPage(4);
            },
          ),
          ListTile(
            title: Text('관심있는 회사'),
            onTap: () {
              Navigator.pop(context);
              pageController.jumpToPage(5);
            },
          ),
          ListTile(
            title: Text('문의사항'),
            onTap: () {
              Navigator.pop(context);
              pageController.jumpToPage(6);
            },
          ),
        ],
      ),
    );
  }
}

class FlippingCardPage extends StatefulWidget {
  final VoidCallback onFlip;
  final bool isFront;

  FlippingCardPage({required this.onFlip, required this.isFront});

  @override
  _FlippingCardPageState createState() => _FlippingCardPageState();
}

class _FlippingCardPageState extends State<FlippingCardPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _flipCard() {
    widget.onFlip();
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/초대장배경사진.png',
                fit: BoxFit.cover,
              ),
            ),
            GestureDetector(
              onTap: _flipCard,
              child: Center(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 800),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                    return AnimatedBuilder(
                      animation: rotate,
                      child: child,
                      builder: (BuildContext context, Widget? child) {
                        final angle = animation.value < 0.5 ? pi * animation.value : pi * (1.0 - animation.value);
                        return Transform(
                          transform: Matrix4.rotationY(angle),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                    );
                  },
                  child: widget.isFront
                      ? Container(
                    key: ValueKey(true),
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2),
                      image: DecorationImage(
                        image: AssetImage('assets/편지지.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '', // 일부러 글씨 추가 X 자연스럽게 하기 위함.
                      style: TextStyle(color: Colors.black, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Container(
                    key: ValueKey(false),
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2),
                      image: DecorationImage(
                        image: AssetImage(''), // 편지지 이미지 추가를 안했음
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '안녕하세요,\n이윤호님의 자기소개 페이지에\n초대받으신 것을 축하드립니다.',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 20,
                minBlastForce: 10,
                emissionFrequency: 0.05,
                numberOfParticles: 10,
                gravity: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/단비배경사진.png', // 업로드한 배경 이미지
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey.withOpacity(0.7),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '안녕하세요! 이윤호의 페이지에 오신 것을 환영합니다.',
                      style: TextStyle(color: Colors.white, fontSize: 32), // 글씨 크기 증가
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '반갑습니다! 저는 단국대학교 소프트웨어학과에 재학중인 20학번 이윤호라고 합니다.\n아래는 제 정보를 간단하게 정리해보았습니다!',
                      style: TextStyle(color: Colors.white, fontSize: 20), // 글씨 크기 증가
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '이름: 이윤호\n'
                          '나이: 24\n'
                          '사는곳: 정자역 인근\n'
                          '학교: 단국대학교 소프트웨어학과\n'
                          '취미: 게임, 영화 감상, 개와 산책하기\n',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HobbiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '나의 취미들',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: HobbyCard(
                    icon: Icons.videogame_asset,
                    title: '게임',
                    description: '어려서부터 게임을 좋아했습니다. 지금은 여전히 게임을 즐기고 있습니다.',
                    imageAsset: 'assets/롤로고.png',
                  ),
                ),
                Expanded(
                  child: HobbyCard(
                    icon: Icons.movie,
                    title: '영화감상',
                    description: '액션, 판타지, 오컬트 공포 영화를 좋아합니다. 영화관에서 보는 것을 즐깁니다.',
                    imageAsset: 'assets/아이언맨로고.png',
                  ),
                ),
                Expanded(
                  child: HobbyCard(
                    icon: Icons.pets,
                    title: '개와 산책하기',
                    description: '집에서 개를 키우다보니 개와 함께 노는게 일상이 되었습니다. 매일 산책을 나가려고 노력중입니다!',
                    imageAsset: 'assets/강아지.png',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MBTIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/MBTI대표사진.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey.withOpacity(0.7),
            child: PersonalitySection(),
          ),
        ),
      ],
    );
  }
}

class CareerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/진로배경사진.jfif',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey.withOpacity(0.7),
            child: CareerSection(),
          ),
        ),
      ],
    );
  }
}

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/contact-bk.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey.withOpacity(0.7),
            child: ContactSection(),
          ),
        ),
      ],
    );
  }
}

class GameCompanyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            '제가 관심 있는 회사들입니다',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/넥슨배경사진.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.blueGrey.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            '넥슨은 한국의 유명한 게임 개발사로, 다양한 인기 게임을 개발 및 서비스하고 있습니다.',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/블리자드배경사진.png', // 업로드한 블리자드 이미지
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.blueGrey.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            '블리자드는 세계적으로 유명한 게임 개발사로, 다양한 장르의 인기 게임을 개발 및 서비스하고 있습니다.',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '안녕하세요! 이윤호의 페이지에 오신 것을 환영합니다.',
              style: TextStyle(color: Colors.white, fontSize: 32), // 글씨 크기 증가
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '반갑습니다! 저는 단국대학교 소프트웨어학과에 재학중인 20학번 이윤호라고 합니다. 아래는 제 정보를 간단하게 정리해보았습니다!',
              style: TextStyle(color: Colors.white, fontSize: 20), // 글씨 크기 증가
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '나의 성격과 MBTI',
              style: TextStyle(color: Colors.white, fontSize: 32), // 글씨 크기 증가
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '제 MBTI는 ISFP입니다. 저는 체계적이고 깔끔하게 살고자 합니다. 또한 분쟁을 싫어하며 조화롭게 지내고자 노력합니다.\n'
                  '사고방식도 유연하고 개방적인 태도를 가지고 있어서 친해지고 싶으면 편하게 다가오셔도 좋습니다!',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CareerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '나의 진로분야',
              style: TextStyle(color: Colors.white, fontSize: 32),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '제가 희망하는 진로분야는 "게임개발" 입니다.\n'
                  '제가 좋아하는 게임과 연관지어서 할 수 있는 직업을 가지는 것이 좋다고 생각했기에 게임개발과 관련된 일을 하고 싶습니다.\n'
                  '항상 열심히 최선을 다하는 게임개발자가 되고 싶습니다.',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Contact',
              style: TextStyle(color: Colors.white, fontSize: 32),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '연락처 및 이메일입니다.\n'
                  '기타 문의사항들은 아래 정보들을 하나로 연락주시면 됩니다.',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Email: youknow0424@naver.com',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Phone: 010-6722-6603',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Instagram: younoya_',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HobbyCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String imageAsset;

  HobbyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  @override
  _HobbyCardState createState() => _HobbyCardState();
}

class _HobbyCardState extends State<HobbyCard> {
  bool _showImage = false;

  void _toggleImage() {
    setState(() {
      _showImage = !_showImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 50),
            SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              widget.description,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _toggleImage,
              child: Text(
                _showImage ? '숨기기' : '더보기',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            if (_showImage)
              Column(
                children: [
                  SizedBox(height: 8),
                  Image.asset(widget.imageAsset),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
