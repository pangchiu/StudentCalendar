class ContentIntro {
  String image;
  String title;
  String description;

  ContentIntro(this.image, this.title, this.description);

  static List<ContentIntro> contents = [
    ContentIntro(
      'images/boy.svg',
      'Student Calendar',
      'Nếu bạn là sinh viên ICTU...',
    ),
    
    ContentIntro(
      'images/girl.svg',
      'Chức năng siêu cấp',
      'Bạn Nhiều lần đau đầu vì lịch học của trường bị lỗi:<'
    ),
    ContentIntro(
      'images/man.svg',
      'Vượt trội',
      'SC giúp giải quyết vấn đề của bạn .fb: "Bình Minh" (Cung cấp giải pháp chống ế cho các bạn nữ)',
    ),
  ];
}
