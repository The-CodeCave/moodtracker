import 'dart:convert';
import 'dart:typed_data';

class CreationResponse {
  final String credId;
  final String response;
  final ByteBuffer rawId;
  final Uint8List attestation;
  CreationResponse({
    required this.credId,
    required this.response,
    required this.attestation,
    required this.rawId,
  });

  CreationResponse copyWith(
      {String? credId,
      String? response,
      Uint8List? attestation,
      ByteBuffer? rawId}) {
    return CreationResponse(
      credId: credId ?? this.credId,
      response: response ?? this.response,
      attestation: attestation ?? this.attestation,
      rawId: rawId ?? this.rawId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'credId': credId,
      'response': response,
      'attestation': attestation.toString(),
    };
  }

  factory CreationResponse.fromMap(Map<String, dynamic> map) {
    return CreationResponse(
      credId: map['credId'] ?? '',
      response: map['response'] ?? '',
      attestation: Uint8List.view(map['attestation'].buffer),
      rawId: map['rawId'].buffer,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreationResponse.fromJson(String source) =>
      CreationResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'CreationResponse(credId: $credId, response: $response, attestation: $attestation)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreationResponse &&
        other.credId == credId &&
        other.response == response &&
        other.attestation == attestation;
  }

  @override
  int get hashCode =>
      credId.hashCode ^ response.hashCode ^ attestation.hashCode;
}
