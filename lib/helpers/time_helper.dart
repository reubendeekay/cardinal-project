import 'package:cloud_firestore/cloud_firestore.dart';

String getCreatedAt(Timestamp time) {
  int seconds = DateTime.now().difference(time.toDate()).inSeconds;
  int minutes = DateTime.now().difference(time.toDate()).inMinutes;
  int hours = DateTime.now().difference(time.toDate()).inHours;
  int days = DateTime.now().difference(time.toDate()).inDays;
  double months = DateTime.now().difference(time.toDate()).inDays / 30;

  if (seconds < 60) {
    return seconds.toString() + " secs ago";
  }
  if (minutes < 60) {
    return minutes.toString() + " mins ago";
  }
  if (hours < 24) {
    return hours.toString() + " hours ago";
  }
  if (days == 1) {
    return days.toString() + " day ago";
  }
  if (days < 30) {
    return days.toString() + " days ago";
  } else if (months < 12) {
    return months.floor().toString() + " months ago";
  }
  return (months / 12).floor().toString() + " years ago";
}
