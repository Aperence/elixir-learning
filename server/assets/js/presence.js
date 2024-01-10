import {Socket, Presence} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
let channel = socket.channel("room:presence", {name: window.location.search.split("=")[1]})
let presence = new Presence(channel)

function renderOnlineUsers(presence) {
  let response = ""

  presence.list((id, {metas: [first, ...rest]}) => {
    console.log([first, ...rest])
    let count = rest.length + 1
    response += `<br>${id} (count: ${count})</br>`
  })

  try{
    document.querySelector("#users").innerHTML = response
  }catch{

  }
}

socket.connect()

presence.onSync(() => renderOnlineUsers(presence))

channel.join()

export default socket