package main

import (
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/gorilla/websocket"
)

var (
	// pongWait is how long we will await a pong response from client
	pongWait = 10 * time.Second
	// pingInterval has to be less than pongWait, We cant multiply by 0.9 to get 90% of time
	// Because that can make decimals, so instead *9 / 10 to get 90%
	// The reason why it has to be less than PingRequency is becuase otherwise it will send a new Ping before getting response
	pingInterval = (pongWait * 9) / 10
)

type ClientList map[*Client]string

type Client struct {
	wsConn   *websocket.Conn
	server   *Server
	egress   chan Event
	clientId string
}

func NewClient(wsConn *websocket.Conn, server *Server) *Client {
	id := wsConn.LocalAddr().String()
	return &Client{
		wsConn:   wsConn,
		server:   server,
		egress:   make(chan Event),
		clientId: id,
	}
}

func (c *Client) readMessages() {
	defer func() {
		c.server.removeClient(c)
	}()
	if err := c.wsConn.SetReadDeadline(time.Now().Add(pongWait)); err != nil {
		log.Println(err)
		return
	}
	c.wsConn.SetPongHandler(c.pongHandler)

	// Uncomment if you want to set  read Messages size limit
	// wsConn.SetReadLimit(511)

	for {
		var req Event
		err := c.wsConn.ReadJSON(&req)
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				fmt.Println("error reading message", err.Error())
			}
			break
		}
		if err := c.server.routeEvent(req, c); err != nil {
			log.Println("error handling message: ", err)
		}
	}
}

func (c *Client) writeMessages() {
	defer func() {
		c.server.removeClient(c)
	}()

	ticker := time.NewTicker(pingInterval)
	for {
		select {
		case message, ok := <-c.egress:
			if !ok {
				if err := c.wsConn.WriteMessage(websocket.CloseMessage, nil); err != nil {
					log.Println("Connection is closed: ", err)
				}
				return
			}

			data, err := json.Marshal(message)
			if err != nil {
				log.Println(err)
				return
			}

			if err := c.wsConn.WriteMessage(websocket.TextMessage, data); err != nil {
				log.Println("Field to send message: ", err)
			}
		case <-ticker.C:
			// Send the Ping
			if err := c.wsConn.WriteMessage(websocket.PingMessage, []byte{}); err != nil {
				log.Println("writemsg: ", err)
				return // return to break this goroutine triggeing cleanup
			}
		}
	}
}

func (c *Client) pongHandler(pongMsg string) error {
	return c.wsConn.SetReadDeadline(time.Now().Add(pongWait))
}
