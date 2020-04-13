(() => {
    class myWebsocketHandler {
        setupSocket() {
            this.socket = new WebSocket("ws://localhost:4000/ws/chat")

            this.socket.addEventListener("open", () => {
                const main = document.getElementById("main")
                main.innerText = ""
                main.classList.remove("disconnected")
            })

            this.socket.addEventListener("message", (event) => {
                console.log(event)

                const eventContent = JSON.parse(event.data)

                const pTag = document.createElement("div")
                pTag.className = "chatEntry"
                const namePart = document.createElement("div")
                namePart.className = "name"
                namePart.innerHTML = eventContent.name + ":"
                pTag.append(namePart)

                const messagePart = document.createElement("div")
                messagePart.className = "messagePart"
                pTag.append(messagePart)
                const request = document.createElement("div")
                request.className = "request"
                messagePart.append(request)
                const message = document.createElement("div")
                message.className = "message"
                messagePart.append(message)

                if (eventContent.diceResults == null) {
                    message.innerHTML = eventContent.message
                } else {
                    message.innerHTML = eventContent.diceResults.join(" + ") + " = " + eventContent.diceResults.reduce((a, b) => a + b, 0)
                    request.innerHTML = eventContent.message
                }

                document.getElementById("main").prepend(pTag)
            })

            this.socket.addEventListener("close", () => {
                document.getElementById("main").classList.add("disconnected")
                this.setupSocket()
            })
        }

        submit(event) {
            event.preventDefault()
            var message
            const name = document.getElementById("name").value
            const input = document.getElementById("message")
            message = input.value
            input.value = ""

            this.socket.send(
                JSON.stringify({
                    data: {
                        message: message,
                        name: name
                    },
                })
            )
        }
        submitRoll(event) {
            event.preventDefault()
            var message
            const name = document.getElementById("name").value
            const num_dice = document.getElementById("num_dice")
            const num_sides = document.getElementById("num_sides")
            message = num_dice.value + 'd' + num_sides.value

            this.socket.send(
                JSON.stringify({
                    data: {
                        message: message,
                        name: name
                    },
                })
            )
        }
    }

    const websocketClass = new myWebsocketHandler()
    websocketClass.setupSocket()

    document.getElementById("button_chat")
        .addEventListener("click", (event) => websocketClass.submit(event))
    document.getElementById("button_roll")
        .addEventListener("click", (event) => websocketClass.submitRoll(event))
})()