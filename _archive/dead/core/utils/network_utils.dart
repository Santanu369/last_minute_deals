import 'dart:io';

bool isNetworkError(Object e) {
  return e is SocketException;
}
