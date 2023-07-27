import 'package:flutter_dotenv/flutter_dotenv.dart';

String clientId = dotenv.get('CLIENT_ID');
String clientSecret = dotenv.get('CLIENT_SECRET');
const int rockMaxId = 15;
const List<String> artistIds = ['0ySFZq3Wd0SQUyJUzmJAeb', '0aqPTOZlKG6ltJHv7BNlsm', '4QvgGvpgzgyUOo8Yp8LDm9', '0SMhG4gXGD4gzLMMz08cQU', '6rs1KAoQnFalSqSU4LTh8g', '4rqJz9fE9prZvQd8WsQv6q', '4WqXqPmUuenMIr4QaFrZXN', '1t17z3vfuc82cxSDMrvryJ', '449AEgfeOxqAuRn0uX6l3u', '4SJ7qRgJYNXB9Yttzs4aSa', '6Gem5Nh6gd9PCtWdzR7Odh', '64tJ2EAv1R6UaZqc4iOCyj', '2IUl3m1H1EQ7QfNbNWvgru', '7HwzlRPa9Ad0I8rK0FPzzK', '6POfB0fHdzXFLWL3RHxLv8'];