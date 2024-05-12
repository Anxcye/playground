package main

import (
	"net"
	"strings"
)

type User struct {
	Name   string
	Addr   string
	C      chan string
	conn   net.Conn
	server *Server
}

func NewUser(conn net.Conn, server *Server) *User {
	userAddr := conn.RemoteAddr().String()
	user := &User{
		Name:   userAddr,
		Addr:   userAddr,
		C:      make(chan string),
		conn:   conn,
		server: server,
	}

	go user.ListerMessage()
	return user
}

func (u *User) Online() {
	// 添加新用户到OnlineMap
	u.server.mapLock.Lock()
	u.server.onlineMap[u.Name] = u
	u.server.mapLock.Unlock()

	//广播当前用户上线信息
	u.server.BroadCast(u, "已上线")
}

func (u *User) Offline() {
	// 删除用户到OnlineMap
	u.server.mapLock.Lock()
	delete(u.server.onlineMap, u.Name)
	u.server.mapLock.Unlock()

	//广播当前用户上线信息
	u.server.BroadCast(u, "下线")

}

func (u *User) SendMessage(msg string) {
	u.conn.Write([]byte(msg))
}

func (u *User) DoMessage(msg string) {
	if msg == "who" {
		u.server.mapLock.Lock()
		for _, user := range u.server.onlineMap {
			onlineMessage := "[" + user.Addr + "]" + user.Name + ": 在线...\n"
			u.SendMessage(onlineMessage)
		}
		u.server.mapLock.Unlock()
	} else if len(msg) > 7 && msg[:7] == "rename|"{
		newName := strings.Split(msg, "|")[1]

		_, ok := u.server.onlineMap[newName]
		if ok{
			u.SendMessage("用户名被占用\n")
		}else{
			u.server.mapLock.Lock()
			delete(u.server.onlineMap, u.Name)
			u.server.onlineMap[newName] = u
			u.server.mapLock.Unlock()

			u.Name = newName
			u.SendMessage("成功" + u.Name + "\n")
		}
	}else{
		u.server.BroadCast(u, msg)
	}
}

func (u *User) ListerMessage() {
	for {
		msg := <-u.C
		u.conn.Write([]byte(msg + "\n"))
	}
}
