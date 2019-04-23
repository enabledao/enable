import * as dotenv from "dotenv";

dotenv.config();

const requireEnvVar = <T>(value: T | undefined, name: string) => {
  if (value === undefined) {
    throw new Error(`Missing required env var: ${name}`);
  }

  return value;
};

const validateOnChain =
  (process.env.VALIDATE_ON_CHAIN || "false").toLowerCase().trim() === "true";
const env = {
  port: requireEnvVar(process.env.PORT, "PORT"),
  sessionSecret: requireEnvVar(process.env.SESSION_SECRET, "SESSION_SECRET"),
  nodeEnv: process.env.NODE_ENV || "development",
  validateOnChain,
  web3Provider: validateOnChain
    ? requireEnvVar(process.env.WEB3_PROVIDER, "WEB3_PROVIDER")
    : ""
};

export { env };
