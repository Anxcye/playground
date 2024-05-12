package main

import (
	"fmt"
	"io"
	"net"
	"sync"
	"time"
)

type Server struct {
	Ip        string
	Port      int
	onlineMap map[string]*User
	mapLock   sync.RWMutex
	Message   chan string
}

func NewServer(ip string, port int) *Server {
	server := &Server{
		Ip:        ip,
		Port:      port,
		onlineMap: make(map[string]*User),
		Message:   make(chan string),
	}
	return server
}

// 监听message
func (s *Server) MessageLitener() {
	for {
		msg := <-s.Message
		s.mapLock.Lock()
		for _, cli := range s.onlineMap {
			cli.C <- msg
		}
		s.mapLock.Unlock()
	}
}
func (s *Server) BroadCast(user *User, msg string) {
	sendMsg := "[" + user.Addr + "]" + user.Name + ":" + msg

	s.Message <- sendMsg
}

func (s *Server) Handler(conn net.Conn) {
	fmt.Println("连接建立成功")

	user := NewUser(conn, s)
	isAlive := make(chan bool)

	user.Online()

	// 接收客户端发送的消息
	go func() {
		buf := make([]byte, 4096)

		for {
			n, err := conn.Read(buf)
			if n == 0 {
				user.Offline()
				return
			}
			if err != nil && err != io.EOF {
				fmt.Println("conn Read err: ", err)
				return
			}
			msg := string(buf[:n-1])

			user.DoMessage(msg)

			isAlive<-true
		}
	}()

	// 阻塞当前go程
	for {
		select {
		case <-isAlive:

		case <-time.After(time.Second * 10):
			user.SendMessage("超时未发言\n")

			close(user.C)

			conn.Close()

			return

		}
	}
}

func (s *Server) Start() {
	listener, err := net.Listen("tcp", fmt.Sprintf("%s:%d", s.Ip, s.Port))
	if err != nil {
		fmt.Println("net.Lister err: ", err)
		return
	}

	defer listener.Close()

	go s.MessageLitener()

	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Println("listener accept err: ", err)
			continue
		}
		go s.Handler(conn)
	}

}
