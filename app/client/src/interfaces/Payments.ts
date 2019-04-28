export interface RepaymentData {
    days: number;
    date: Date;
    principalDue: number;
    loanBalance: number;
    interest: number;
    fees: number;
    penalties: number;
    due: number;
}