package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
)

type Message struct {
	Greeting string `json:"greeting"`
}

var (
	wsUpgrader = websocket.Upgrader{
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}
	wsConn *websocket.Conn
)

func WsEndpoint(w http.ResponseWriter, r *http.Request) {
	wsUpgrader.CheckOrigin = func(r *http.Request) bool {
		// check the http.Request
		// make sure it's OK to access
		return true
	}
	wsConn, err := wsUpgrader.Upgrade(w, r, nil)
	if err != nil {
		fmt.Println("could not upgrade:", err.Error())
	}
	defer wsConn.Close()
	// event loop
	wsConn.SetCloseHandler(func(_code int, _text string) error {
		// on disconnect method
		fmt.Println("Client disconnected")
		return wsConn.Close()
	})

	fmt.Println("Client connected:", wsConn.RemoteAddr().String())

	wsConn.WriteMessage(websocket.TextMessage, []byte("Hello from servers"))
	for {
		var msg Message
		err := wsConn.ReadJSON(&msg)
		if err != nil {
			fmt.Println("error reading message", err.Error())
			break
		}
		fmt.Println("message Received:", msg.Greeting)
	}
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/socket", WsEndpoint)
	fmt.Println("Server started @ http://localhost:3000")
	http.ListenAndServe(":3000", router)
}
