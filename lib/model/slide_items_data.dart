class SlideData {
  String? imageUrl;
  int? number;
  String? title;
  String? description;

  SlideData({
    this.imageUrl,
    this.number,
    this.title,
    this.description,
  });
}

final slideDataList = [
  SlideData(
    imageUrl: "assets/images/img.png",
    number: 1,
    title: "Sign in with google",
    description:
        "You will started your conversation by click button below and then select any google account you mine",
  ),
  SlideData(
    imageUrl: "assets/images/img.png",
    number: 2,
    title: "Begin your conversation",
    description:
        "click typing box and type any thing you want to talk about him with your friends maybe about eating Lol",
  ),
  SlideData(
    imageUrl: "assets/images/img.png",
    number: 3,
    title: "Delete message",
    description:
        "Jost slide your message to the left or right to remove it from the chat",
  ),
  SlideData(
    imageUrl: "assets/images/img.png",
    number: 3,
    title: "Logout",
    description:
        "It to git red of more talking in this chat Lol (kidding) maybe you need to sign in with another account so this button will help you",
  ),
];
