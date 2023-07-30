import { Server } from "socket.io";
import { instrument } from "@socket.io/admin-ui";
import { NodeAudioVolumeMixer as volume } from "node-audio-volume-mixer";
import os from "os";
const PORT = 3000;

interface ServerToClientEvents {}

interface ClientToServerEvents {
  isMute: (_: null, cal: (mute: boolean) => void) => void;
  setMute: (sate: boolean) => void;
  getMac: (_: null, cal: (mac: string) => void) => void;
  setVolume: (vol: number) => void;
  getVolume: (_: null, cal: (vol: number) => void) => void;
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
    origin: "*",
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

  socket.on("isMute", (_, cal) => cal(volume.isMasterMuted()));

  socket.on("getMac", (_, cal) => cal(getMacAddress()));

  socket.on("getVolume", (_, cal) =>
    cal(volume.getMasterVolumeLevelScalar() * 100)
  );
  socket.on("setVolume", (vol) => {
    volume.setMasterVolumeLevelScalar(vol / 100);
  });
  socket.on("setMute", (state) => {
    volume.muteMaster(state);
  });
  socket.on("disconnect", (reason) => {
    console.log(`socket ${socket.id} disconnected due to ${reason}`);
  });
});
function getMacAddress() {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]!) {
      if (iface.family === "IPv4" && !iface.internal) {
        return iface.mac;
      }
    }
  }
  return "";
}
