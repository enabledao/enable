import * as http from "./http";

type BaseResponse = {
  success: boolean;
  message: string;
};

export const session = (): Promise<BaseResponse & { token: string }> =>
  http.post(`/session`);

export const getReceivedData = (
  token: string
): Promise<BaseResponse & { receivedData: { email: string } }> =>
  http.get(`/received-data?token=${encodeURIComponent(token)}`);
