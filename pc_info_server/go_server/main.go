package main

import (
	"fmt"
	"net/http"
	"sync"

	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
)

type Server struct {
	clients   ClientList
	handelers map[string]EventHandler
	sync.RWMutex
}

func NewServer() *Server {
	return &Server{
		clients:   make(ClientList),
		handelers: make(map[string]EventHandler),
	}
}

var wsUpgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

func (s *Server) wsEndpoint(w http.ResponseWriter, r *http.Request) {
	wsUpgrader.CheckOrigin = func(r *http.Request) bool {
		// check the http.Request
		// make sure it's OK to access
		return true
	}
	wsConn, err := wsUpgrader.Upgrade(w, r, nil)
	if err != nil {
		fmt.Println("could not upgrade:", err.Error())
	}
	// defer wsConn.Close()
	// // event loop
	// wsConn.SetCloseHandler(func(_code int, _text string) error {
	// 	// on disconnect method
	// 	fmt.Println("Client disconnected")
	// 	return wsConn.Close()
	// })
	//
	// fmt.Println("Client connected:", wsConn.RemoteAddr().String())
	//
	// wsConn.WriteMessage(websocket.TextMessage, []byte("Hello from servers"))
	// for {
	// 	var msg any
	// 	err := wsConn.ReadJSON(&msg)
	// 	if err != nil {
	// 		fmt.Println("error reading message", err.Error())
	// 		break
	// 	}
	// 	fmt.Println("message Received:", msg)
	// }
	client := NewClient(wsConn, s)
	s.addClient(client)

	// String client process
	go client.readMessages()
}

func (s *Server) addClient(client *Client) {
	s.Lock()
	defer s.Unlock()

	s.clients[client] = client.wsConn.LocalAddr().Network()
}

func (s *Server) removeClient(client *Client) {
	s.Lock()
	defer s.Unlock()

	if _, ok := s.clients[client]; ok {
		client.wsConn.Close()
		delete(s.clients, client)
	}
}

func main() {
	router := mux.NewRouter()
	server := NewServer()
	router.HandleFunc("/socket", server.wsEndpoint)
	fmt.Println("Server started @ http://localhost:3000")
	http.ListenAndServe(":3000", router)
}
