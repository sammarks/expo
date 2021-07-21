export declare type LocalAuthenticationResult = {
    success: true;
} | {
    success: false;
    error: string;
};
export declare enum AuthenticationType {
    FINGERPRINT = 1,
    FACIAL_RECOGNITION = 2,
    IRIS = 3
}
export declare enum SecurityLevel {
    NONE = 0,
    SECRET = 1,
    BIOMETRIC = 2
}
export declare type LocalAuthenticationOptions = {
    promptMessage?: string;
    cancelLabel?: string;
    disableDeviceFallback?: boolean;
    fallbackLabel?: string;
};
