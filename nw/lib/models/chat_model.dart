class ChatModel {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  ChatModel({this.name, this.message, this.time, this.avatarUrl});
}
  List<ChatModel> dummyData = [
    new ChatModel(
        name: "John",
        message: "Olá, Bem vindo ao Chat",
        time: "15:30",
        avatarUrl:
            "https://www.shareicon.net/data/128x128/2017/01/06/868320_people_512x512.png"),
    
  ];

