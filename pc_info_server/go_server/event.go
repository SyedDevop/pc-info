package main

import "encoding/json"

type Event struct {
	Type    string          `json:"type"`
	Payload json.RawMessage `json:"payload"`
}

type EventHandler func(event Event) error

const (
	IsMute = "is_mute"
)

type IsMuteEvent bool
