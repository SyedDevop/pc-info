package main

import (
	"errors"
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
	ser := &Server{
		clients:   make(ClientList),
		handelers: make(map[string]EventHandler),
	}
	ser.setupEventHandlers()
	return ser
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
	go client.writeMessages()
}

func (s *Server) addClient(client *Client) {
	s.Lock()
	defer s.Unlock()

	clientId := client.wsConn.LocalAddr().String()

	s.clients[client] = clientId
	fmt.Println("New client connected:", clientId)
}

func (s *Server) removeClient(client *Client) {
	s.Lock()
	defer s.Unlock()

	if _, ok := s.clients[client]; ok {
		client.wsConn.Close()
		delete(s.clients, client)
	}
}

func (s *Server) setupEventHandlers() {
	s.handelers[IsMute] = SendIsMute
}

func SendIsMute(event Event, c *Client) error {
	fmt.Println(event)

	return nil
}

func (s *Server) routeEvent(event Event, c *Client) error {
	if handler, ok := s.handelers[event.Type]; ok {
		if err := handler(event, c); err != nil {
			return err
		}
		return nil
	} else {
		return errors.New("there is no such event types")
	}
}

func main() {
	router := mux.NewRouter()
	server := NewServer()
	router.HandleFunc("/socket", server.wsEndpoint)
	fmt.Println("Server started @ http://localhost:3000")
	http.ListenAndServe(":3000", router)
}
