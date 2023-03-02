import * as functions from "firebase-functions";
import {
    generateAuthenticationOptions,
    generateRegistrationOptions, VerifiedRegistrationResponse, verifyAuthenticationResponse, verifyRegistrationResponse,
} from "@simplewebauthn/server";
import { v4 } from "uuid";
import { ORIGIN, RP_ID, RP_NAME } from "./rpConstants";
import { auth, firestore } from "firebase-admin";
import base64url from "base64url";
import * as admin from "firebase-admin";
import * as cors from "cors";
import { ConfirmRegistrationRequest } from "./types/confirmRegistrationResponse";
admin.initializeApp();
const corsHandler = cors({ origin: true });
// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const generateRegistrationOps = functions.region("europe-west3").https.onRequest(
    async (request, response) => {
        corsHandler(request, response, async () => {
            try {
                await auth().getUserByEmail(request.query.email as string);
                response.status(400).send("User already exists");
            } catch (error) {
                const newId = v4();
                const options = generateRegistrationOptions({
                    rpName: RP_NAME,
                    rpID: request.query.debug == "true" ? "localhost" : RP_ID,
                    userID: newId,
                    userName: request.query.email as string,
                    userDisplayName: request.query.email as string,
                    timeout: 60000,
                    attestationType: "none",
                    authenticatorSelection: {
                        residentKey: "required",
                        userVerification: "required",
                    },
                });
                console.log(options);
                await firestore().collection("register-challenges").add({
                    email: request.query.email,
                    userID: newId,
                    ...options,
                    createdAt: new Date().toISOString(),
                });
                response.status(200).send(options);
            }
        });
    });

export const confirmRegistration = functions.region("europe-west3").https.onRequest(
    async (request, response) => {
        corsHandler(request, response, async () => {
            console.log(request.body);
            const {email, clientResponse} = JSON.parse(request.body) as ConfirmRegistrationRequest;

            console.log(clientResponse);
            console.log(clientResponse.response);
            console.log(clientResponse.response.clientDataJSON);
            const challengeRef = (await firestore()
                .collection("register-challenges")
                .where("email", "==", email)
                .get()).docs[0];
            let verification: VerifiedRegistrationResponse;
            try {
                verification = await verifyRegistrationResponse({
                    response: clientResponse,
                    expectedChallenge: challengeRef.data().challenge,
                    expectedOrigin: ORIGIN,
                    expectedRPID: request.query.debug == "true" ? "localhost" : RP_ID,
                });
            } catch (error) {
                console.error(error);
                response.status(401).send("Error verifying response");
                return;
            }

            const { verified } = verification;

            if (verified) {
                const { id, type } = clientResponse;
                const { registrationInfo } = verification;
                await auth().createUser({
                    email: email,
                    uid: challengeRef.data().userID,
                });
                await firestore().collection("credentials").add({
                    userID: challengeRef.data().userID,
                    user: email,
                    id,
                    type,
                    credentialPublicKey: base64url(Buffer.from(registrationInfo!.credentialPublicKey)),
                    counter: registrationInfo?.counter,
                    credentialID: base64url(Buffer.from(registrationInfo!.credentialID)),
                });
                await challengeRef.ref.delete();
                const token = await auth().createCustomToken(challengeRef.data().userID);
                response.status(200).send(token);
            } else {
                response.status(401).send("Response invalid");
            }
        });
    });

export const generateAuthenticationOps = functions.region("europe-west3").https.onRequest(
    async (request, response) => {
        corsHandler(request, response, async () => {
            const transactionId = v4();
            const options = generateAuthenticationOptions({
                rpID: request.query.debug == "true" ? "localhost:5000" : RP_ID,
                userVerification: "required",
            });
            await firestore().collection("auth-challenges").add({
                transactionId,
                challenge: options.challenge,
                rpId: options.rpId,
                createdAt: new Date().toISOString(),
            });
            response.status(200).send({...options, transactionId});
        });
    });

export const confirmAuthentication = functions.region("europe-west3").https.onRequest(
    async (request, response) => {
        corsHandler(request, response, async () => {
            const { transactionId, clientResponse, userID } = JSON.parse(request.body);
            const challengeRef = (await firestore()
                .collection("auth-challenges")
                .where("transactionId", "==", transactionId)
                .get()).docs[0];
            const credentialRef = (await firestore()
                .collection("credentials")
                .where("userID", "==", userID)
                .get()).docs[0];
            const { verified } = await verifyAuthenticationResponse({
                response: clientResponse,
                expectedChallenge: challengeRef.data().challenge,
                expectedOrigin: ORIGIN,
                expectedRPID: request.query.debug == "true" ? "localhost" : RP_ID,
                authenticator: {
                    credentialID: base64url.toBuffer(credentialRef.data().id),
                    counter: credentialRef.data().counter,
                    credentialPublicKey: base64url.toBuffer(credentialRef.data().credentialPublicKey),
                },
            });
            if (verified) {
                const token = await auth().createCustomToken(credentialRef.data().userID);
                response.status(200).send(token);
            } else {
                response.status(401).send("Response invalid");
            }
        });
    });
