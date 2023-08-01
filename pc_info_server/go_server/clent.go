package main

import (
	"fmt"
	"log"

	"github.com/gorilla/websocket"
)

type ClientList map[*Client]string

type Client struct {
	wsConn *websocket.Conn
	server *Server
	egress chan []byte
}

func NewClient(wsConn *websocket.Conn, server *Server) *Client {
	return &Client{
		wsConn: wsConn,
		server: server,
		egress: make(chan []byte),
	}
}

func (c *Client) readMessages() {
	defer func() {
		c.server.removeClient(c)
	}()

	for {
		_, payload, err := c.wsConn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				fmt.Println("error reading message", err.Error())
			}
			break
		}

		println(string(payload))
	}
}

func (c *Client) writeMessages() {
	defer func() {
		c.server.removeClient(c)
	}()

	for {
		select {
		case message, ok := <-c.egress:
			if !ok {
				if err := c.wsConn.WriteMessage(websocket.CloseMessage, nil); err != nil {
					log.Println("Connection is closed: ", err)
				}
				return
			}
			if err := c.wsConn.WriteMessage(websocket.TextMessage, message); err != nil {
				log.Println("Field to send message: ", err)
			}
		}
	}
}
