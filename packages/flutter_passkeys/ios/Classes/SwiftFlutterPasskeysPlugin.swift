import Flutter
import UIKit
import AuthenticationServices

@available(iOS 16.0, *)
public class SwiftFlutterPasskeysPlugin: NSObject, FlutterPlugin, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static var channel:FlutterMethodChannel? = nil;
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "flutter_passkeys", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPasskeysPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if(call.method == "create_passkey") {
          guard let args = call.arguments else {
              result("iOS could not recognize flutter arguments in method: (sendParams)");
              return;
        }
          if let myArgs = args as? [String: Any],
                    let challenge = myArgs["challenge"] as? String,
                    let userID = myArgs["userID"] as? String,
                    let displayName = myArgs["displayName"] as? String,
                    let relyingParty = myArgs["relyingParty"] as? String,
                    let userVerificationPreference = myArgs["userVerificationPreference"] as? String

          {
              var verificationPref = mapUserVerification(userVerificationPreference: userVerificationPreference);
              createPasskey(
                challenge: challenge.data(using: .utf8)!,
                userID: userID.data(using: .utf8)!,
                displayName: displayName,
                relyingParty: relyingParty,
                userVerificationPreference: verificationPref
              );
              result("Auth started. Callback on passkey_auth_complete");
              return;
          }
      } else if(call.method == "assert_passkey") {
          guard let args = call.arguments else {
              result("iOS could not recognize flutter arguments in method: (sendParams)");
              return;
        }
          if let myArgs = args as? [String: Any],
                    let challenge = myArgs["challenge"] as? String,
                    let relyingParty = myArgs["relyingParty"] as? String,
                    let allowedCredentials = myArgs["allowedCredentials"] as? [String]?,
                    let userVerificationPreference = myArgs["userVerificationPreference"] as? String

          {
              var verificationPref = mapUserVerification(userVerificationPreference: userVerificationPreference);
              var mappedAllowedCreds: [ASAuthorizationPlatformPublicKeyCredentialDescriptor]?;
              
              if(allowedCredentials != nil && !allowedCredentials!.isEmpty) {
                  mappedAllowedCreds = allowedCredentials!.map {ASAuthorizationPlatformPublicKeyCredentialDescriptor.init(credentialID: Data(base64Encoded:  $0)!) }
              }
              assertPasskey(
                challenge: challenge.data(using: .utf8)!,
                relyingParty: relyingParty,
                allowedCred: mappedAllowedCreds,
                userVerificationPreference: verificationPref
              );
              result("Auth started. Callback on passkey_auth_complete");
              return;
          }
      }
      result("iOS " + UIDevice.current.systemVersion)
  }
    
    public func createPasskey(challenge: Data, userID: Data, displayName: String, relyingParty: String, userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference?) {
        let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: relyingParty)
        let platformKeyRequest = platformProvider.createCredentialRegistrationRequest(challenge: challenge, name: displayName, userID: userID);
        
        if(userVerificationPreference != nil) {
            platformKeyRequest.userVerificationPreference = userVerificationPreference!;
        }
        let authController = ASAuthorizationController(authorizationRequests: [platformKeyRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
       
        authController.performRequests()
    }
    
    public func assertPasskey(challenge: Data, relyingParty: String, allowedCred: [ASAuthorizationPlatformPublicKeyCredentialDescriptor]?, userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference?) {
        let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: relyingParty)
        let platformKeyRequest = platformProvider.createCredentialAssertionRequest(challenge: challenge)
        
        if(allowedCred != nil && !allowedCred!.isEmpty) {
            platformKeyRequest.allowedCredentials = allowedCred!;
        }
        
        if(userVerificationPreference != nil) {
            platformKeyRequest.userVerificationPreference = userVerificationPreference!;
        }
        
        let authController = ASAuthorizationController(authorizationRequests: [platformKeyRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if(authorization.credential is ASAuthorizationPlatformPublicKeyCredentialRegistration) {
            let auth = authorization.credential as! ASAuthorizationPlatformPublicKeyCredentialRegistration;
            let decodedResponse = String(decoding: auth.rawClientDataJSON, as: UTF8.self );
            //let decodedCredId = String(decoding: auth.credentialID, as:  );
            print(decodedResponse)
            let jsonObject: [String: Any] = [
                "credId": auth.credentialID.base64EncodedString(),
                "response": decodedResponse,
                "attestation": auth.rawAttestationObject!
            ]
            print(jsonObject);
            SwiftFlutterPasskeysPlugin.channel!.invokeMethod("passkey_create_complete", arguments: jsonObject);
            return;
        }else if(authorization.credential is ASAuthorizationPlatformPublicKeyCredentialAssertion) {
            let auth = authorization.credential as! ASAuthorizationPlatformPublicKeyCredentialAssertion;
            let decodedResponse = String(decoding: auth.rawClientDataJSON, as: UTF8.self );
            print(decodedResponse)
            let jsonObject: [String: Any] = [
                "credId": auth.credentialID.base64EncodedString(),
                "response": decodedResponse,
                "signature": auth.signature!,
                "authenticatorData": auth.rawAuthenticatorData!,
                "userId": String(decoding: auth.userID, as: UTF8.self )
            ]
            print(jsonObject);
            SwiftFlutterPasskeysPlugin.channel!.invokeMethod("passkey_auth_complete", arguments: jsonObject);
            return;
        }
        print("Type casting failed");
        
        print(authorization.credential);
        print(authorization)
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error);
        print("Authentication failed; please try again");
        SwiftFlutterPasskeysPlugin.channel!.invokeMethod("passkey_auth_failed", arguments: "Failed, please try again");
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let viewController: UIViewController =
                    (UIApplication.shared.delegate?.window??.rootViewController)!;
        return viewController.view.window!
    }
    
    private func mapUserVerification(userVerificationPreference:String) -> ASAuthorizationPublicKeyCredentialUserVerificationPreference? {
        var mappedPref:ASAuthorizationPublicKeyCredentialUserVerificationPreference?;
        
        if(userVerificationPreference == "required") {
            mappedPref = .required;
        }
        else if(userVerificationPreference == "prefered") {
            mappedPref = .preferred;
        }
        else if(userVerificationPreference == "discouraged") {
            mappedPref = .discouraged;
        } else {
            mappedPref = nil;
        }
        return mappedPref;
    }
    
    private func mapAttestationRequest(attestationRequest:String) -> ASAuthorizationPublicKeyCredentialAttestationKind? {
        var mappedPref:ASAuthorizationPublicKeyCredentialAttestationKind?;
        
        if(attestationRequest == "direct") {
            mappedPref = .direct;
        }
        else if(attestationRequest == "enterprise") {
            mappedPref = .enterprise;
        }
        else if(attestationRequest == "indirect") {
            mappedPref = .indirect;
        }
        else if(attestationRequest == "none") {
            mappedPref = ASAuthorizationPublicKeyCredentialAttestationKind.none;
        }
        else {
            mappedPref = nil;
        }
        return mappedPref;
    }
}
