import express from "express";
import * as bodyParser from "body-parser";
import helmet from "helmet";
import compress from "compression";
import session from "express-session";
import uuid from "uuid";
import path from "path";
import http from "http";
import morgan from "morgan";
import { validateResponseData } from "@bloomprotocol/share-kit";

import { loggedInSession } from "./middleware";
import { applySocket, sendSocketMessage } from "./socket";
import { env } from "./environment";

/**
 * WARNING: This "database" is NOT intended to be used in production applications.
 */
const database: { [key: string]: string } = {};

const sessionParser = session({
  saveUninitialized: false,
  secret: env.sessionSecret,
  resave: false
});

const app = express();

app.use(helmet());
app.use(morgan("tiny"));

app.use(sessionParser);

app.use(
  bodyParser.json({
    type: "*/*",
    verify: (req, _, buf) => {
      (req as any).rawBody = buf;
      return true;
    },
    limit: "10mb" // https://stackoverflow.com/a/19965089/1165441
  })
);

app.use(compress());

app.use(express.static(path.join(__dirname, "client")));

app.post("/session", (req, res) => {
  if (req.session!.userId === undefined) {
    const id = uuid.v4();
    req.session!.userId = id;
  }

  return res.status(200).json({
    success: true,
    message: "Session updated",
    token: req.session!.userId
  });
});

app.delete("/clear-session", loggedInSession, (req, res) => {
  if (req.session) {
    req.session.destroy(err => {
      if (err) {
        res.status(500).send({
          success: false,
          message: "Something went wrong while destroying session"
        });
      } else {
        res.send({ success: true, message: "Session destroyed" });
      }
    });
  }
});

app.post("/scan", async (req, res) => {
  try {
    const verifiedData = await validateResponseData(req.body, {
      validateOnChain: env.validateOnChain,
      web3Provider: env.web3Provider
    });
    if (verifiedData.errors.length) {
      res.status(400).json({
        success: false,
        message: "Shared data is not valid",
        verifiedData
      });
      return;
    }

    const consumableEmailData = verifiedData.data.find(
      data => data.type === "email"
    );
    const email = consumableEmailData && consumableEmailData.data;
    if (!email || email.trim() === "") {
      throw new Error("Missing email");
    }

    const sharePayload = JSON.stringify({ email });
    if (req.query["share-kit-from"] === "button") {
      database[req.body.token] = sharePayload;
    } else {
      await sendSocketMessage({
        userId: req.body.token,
        type: "share-kit-scan",
        payload: sharePayload
      });
    }

    res.status(200).json({ success: true, message: "Message Sent" });
  } catch (err) {
    if (err.message === "Missing email") {
      res.status(404).send({
        success: false,
        message: "Email is missing from completed attestations"
      });
    } else {
      res.status(500).send({
        success: false,
        message: "Something went wrong while sending message"
      });
    }
  }
});

app.get("/received-data", async (req, res) => {
  const receivedData = database[req.query.token];
  if (receivedData) {
    res.status(200).json({
      success: true,
      receivedData: JSON.parse(receivedData)
    });
    delete database[req.query.token];
    return;
  }

  return res.status(400).json({
    success: false,
    message: "Something went wrong while attempting to query for received data"
  });
});

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "client", "index.html"));
});

const server = http.createServer(app);

applySocket(server, sessionParser);

server.listen(env.port, () =>
  console.log(`Listening on http://localhost:${env.port}`)
);
