import { LoanMetadata } from '../interfaces/Loans';
import { UserMetadata } from '../interfaces/Users';
import { TokenMetadata } from '../interfaces/Tokens';

let tokens: Map<string, TokenMetadata> = new Map<string, TokenMetadata>();
let users: Map<number, UserMetadata> = new Map<number, UserMetadata>();
let loans: Map<number, LoanMetadata> = new Map<number, LoanMetadata>();

// Token metadata by address
tokens.set('0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48', {
    imgSrc: 'https://etherscan.io/token/images/centre-usdc_28.png',
    name: 'USDC',
    address: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
})

// User metadata by id
users.set(0, {
    imgSrc: "",
    name: "Widya Imanesti",
    attestations: [],
    stakers: [],
})

// Loan metadata by id

export const database = {
    tokens: tokens,
    users: users
}