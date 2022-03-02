import 'package:draw/draw.dart' as draw;
import 'package:html_unescape/html_unescape.dart';

class Comment {
  final String authorName;
  final String content;
  final DateTime createdTime;

  Comment.fromDraw(draw.Comment comment)
      : authorName = comment.author,
        content = comment.body == null
            ? ""
            : HtmlUnescape().convert(comment.body!.trim()),
        createdTime = comment.createdUtc;
}
