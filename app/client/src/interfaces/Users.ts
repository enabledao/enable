export interface Identity {
    name: string,
    id?: string;
    imgSrc?: string;
    url?: string
}

export interface UserMetadata {
    imgSrc?: string,
    name: string,
    attestations?: string[],
    stakers?: string[]
}

export interface User {
    address: string;
    metadata?: UserMetadata;
    verifiedIdentities?: Identity[];//Bloom, 3D Box
    verifiedSocialAccounts?: Identity[]; //Linkedin, Twitter, facebook
}

export interface ContributerMetadata {
    img: string;
    text: string;
}