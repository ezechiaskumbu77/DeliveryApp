import 'dart:convert';

class NotificationModel {
  String id;
  String date;
  String title;
  String body;
  bool viewed;
  String orderID,userID;
  NotificationModel({this.id, this.date, this.title, this.body, this.orderID, this.userID, this.viewed});



  factory NotificationModel.fromJson(Map<String, dynamic> jsonData) {
    return NotificationModel(
      id: jsonData['_id'],
      date: jsonData['created'],
      viewed:jsonData['viewed'],
      title: jsonData['title'],
      body: jsonData['body'],
      orderID: jsonData['orderID'],
      userID: jsonData['userID'],
    );
  }

  static Map<String, dynamic> toMap(NotificationModel notifi) => {
    'id': notifi.id,
    'created': notifi.date,
    'title': notifi.title,
    'body': notifi.body,
    'viewed': notifi.viewed,
    'orderID': notifi.orderID,

  };

  static String encode(List<NotificationModel> notifications) => json.encode(
    notifications
        .map<Map<String, dynamic>>((music) => NotificationModel.toMap(music))
        .toList(),
  );

  static List<NotificationModel> decode(String noti) =>
      (json.decode(noti) as List<dynamic>)
          .map<NotificationModel>((item) => NotificationModel.fromJson(item))
          .toList();
}

List<NotificationModel> NotificationModelFromJson(dynamic jsonData) {
  
  List<NotificationModel> listAll = <NotificationModel>[];

  for (var item in jsonData) {
    listAll.add(NotificationModel.fromJson(item));
  }
 
  return listAll;
}

 
NotificationModel OneNotificationModelFromJson(dynamic jsonData) {
  final data = json.decode(jsonData);

 
  return NotificationModel.fromJson(data['data']);
}
