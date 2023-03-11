import 'dart:convert';

import 'package:flutter/foundation.dart';

class AuthenticationResponse {
  final String credId;
  final String response;
  final Uint8List signature;
  final Uint8List authenticatorData;
  final String userId;
  final Uint8List rawId;
  final Uint8List clientDataJSON;

  AuthenticationResponse({
    required this.credId,
    required this.response,
    required this.authenticatorData,
    required this.userId,
    required this.signature,
    required this.rawId,
    required this.clientDataJSON,
  });

  AuthenticationResponse copyWith({
    String? credId,
    String? response,
    Uint8List? authenticatorData,
    String? userId,
    Uint8List? signature,
    Uint8List? rawId,
    Uint8List? clientDataJSON,
  }) {
    return AuthenticationResponse(
      credId: credId ?? this.credId,
      response: response ?? this.response,
      authenticatorData: authenticatorData ?? this.authenticatorData,
      userId: userId ?? this.userId,
      signature: signature ?? this.signature,
      rawId: rawId ?? this.rawId,
      clientDataJSON: clientDataJSON ?? this.clientDataJSON,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'credId': credId,
      'response': response,
      'authenticatorData': authenticatorData.toString(),
      'userId': userId,
      'signature': signature.toString(),
    };
  }

  factory AuthenticationResponse.fromMap(Map<String, dynamic> map) {
    return AuthenticationResponse(
      credId: map['credId'] ?? '',
      response: map['response'] ?? '',
      authenticatorData: Uint8List.view(map['authenticatorData'].buffer),
      userId: map['userId'] ?? '',
      signature: Uint8List.view(map['signature'].buffer),
      rawId: Uint8List.view(map['rawId'].buffer),
      clientDataJSON: Uint8List.view(map['clientDataJSON'].buffer),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationResponse.fromJson(String source) =>
      AuthenticationResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthenticationResponse(credId: $credId, response: $response, authenticatorData: $authenticatorData, userId: $userId, signature: $signature)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationResponse &&
        other.credId == credId &&
        other.response == response &&
        other.authenticatorData == authenticatorData &&
        other.userId == userId &&
        other.signature == signature;
  }

  @override
  int get hashCode {
    return credId.hashCode ^
        response.hashCode ^
        authenticatorData.hashCode ^
        userId.hashCode ^
        signature.hashCode;
  }
}
