import 'dart:convert';


QuestionsResponse questionsResponseFromJson(String str) =>
    QuestionsResponse.fromJson(json.decode(str));

String questionsResponseToJson(QuestionsResponse data) =>json.encode(data.toJson());

class QuestionsResponse {
  List<Question> data;
  QuestionMeta meta;
  bool success;
  int status;

  QuestionsResponse({
     this.data,
     this.meta,
     this.success,
     this.status,
  });

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) => QuestionsResponse(
        data: List<Question>.from(json['data'].map((x) => Question.fromJson(x))),
        meta: QuestionMeta.fromJson(json['meta']),
        success: json['success'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
        "success": success,
        "status": status,
      };
}

class Question {
  String name;
  int productId;
  String text;
  String time;
  List<Reply> replies;

  Question({
     this.name,
     this.productId,
     this.text,
     this.time,
     this.replies,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        name: json['name'],
        productId: json['product_id'],
        text: json['text'],
        time: json['time'],
        replies: List<Reply>.from(json['replies'].map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "product_id": productId,
        "text": text,
        "time": time,
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class Reply {
  String name;
  int productId; // It can be null
  String text;
  String time;

  Reply({
     this.name,
     this.productId,
     this.text,
     this.time,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        name: json['name'],
        productId: json['product_id'],
        text: json['text'],
        time: json['time'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "product_id": productId,
        "text": text,
        "time": time,
      };
}

class QuestionMeta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  QuestionMeta({
     this.currentPage,
     this.from,
     this.lastPage,
     this.path,
     this.perPage,
     this.to,
     this.total,
  });

  factory QuestionMeta.fromJson(Map<String, dynamic> json) => QuestionMeta(
        currentPage: json['current_page'],
        from: json['from'],
        lastPage: json['last_page'],
        path: json['path'],
        perPage: json['per_page'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

