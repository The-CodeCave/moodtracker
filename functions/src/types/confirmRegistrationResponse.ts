export interface ConfirmRegistrationRequest {
    email: string;
    clientResponse: {
        rawId: string;
        response: {
            clientDataJSON: string;
            attestationObject: string;
        };
        type:"public-key"
        id:string
        clientExtensionResults: any;
        transports?: any[];
    }
}
