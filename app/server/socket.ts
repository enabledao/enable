import express from "express";
import http from "http";
import WebSocket from "ws";

type WebSocketMap = {
  [userId: string]: WebSocket | undefined;
};

const webSockets: WebSocketMap = {};

export const sendSocketMessage = (message: {
  userId: string;
  type: string;
  payload: string;
}) => {
  const socket = webSockets[message.userId];

  if (socket === undefined) return;

  return new Promise((resolve, reject) => {
    socket.send(JSON.stringify([message.type, message.payload]), err => {
      if (err) reject(err);

      resolve();
    });
  });
};

export const applySocket = (
  server: http.Server,
  sessionParser: express.RequestHandler
) => {
  const wss = new WebSocket.Server({
    verifyClient: (info, done) => {
      console.log("Parsing session from request...");
      sessionParser(info.req as any, {} as any, () => {
        done((info.req as any).session.userId !== undefined);
      });
    },
    server
  });

  wss.on("connection", (ws, req) => {
    webSockets[(req as any).session.userId] = ws;
  });
};
