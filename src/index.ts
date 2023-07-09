import { Server } from "socket.io";
import { instrument } from "@socket.io/admin-ui";
import { NodeAudioVolumeMixer as volume } from "node-audio-volume-mixer";
const PORT = 3000;

interface ServerToClientEvents {}

interface ClientToServerEvents {
  isMute: () => boolean;
}

interface InterServerEvents {
  ping: () => void;
}

interface SocketData {
  user_id: string;
}

const io = new Server<
  ClientToServerEvents,
  ServerToClientEvents,
  InterServerEvents,
  SocketData
>(PORT, {
  cors: {
    origin: ["https://admin.socket.io"],
    credentials: true,
  },
});
console.log("Socket Server started @ http://localhost:" + PORT);

instrument(io, {
  auth: false,
  mode: "development",
});

io.on("connection", (socket) => {
  console.log(`socket ${socket.id} connected`);

  socket.on("isMute", () => volume.isMasterMuted());

  socket.on("disconnect", (reason) => {
    console.log(`socket ${socket.id} disconnected due to ${reason}`);
  });
});
