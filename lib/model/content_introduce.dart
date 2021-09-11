class ContentIntro {
  String image;
  String title;
  String description;

  ContentIntro(this.image, this.title, this.description);

  static List<ContentIntro> contents = [
    ContentIntro(
      'images/boy.svg',
      'Student Calendar',
      'Vũ trụ đệ nhất siêu cấp ứng dụng vip pro của minh đẹp trai làm ra xứng đáng đoạt giải nobel thế giới.',
    ),
    
    ContentIntro(
      'images/girl.svg',
      'Chức năng siêu cấp',
      'Dễ dàng theo dõi lịch học cá nhân và quản lí thời gian biểu cùng vô vàn tiện ích khác'
    ),
    ContentIntro(
      'images/man.svg',
      'Vượt trội',
      'Chỉ dành cho người thông minh ,đẹp trai ,khoai to và là sân chơi cho giới trẻ',
    ),
  ];
}
