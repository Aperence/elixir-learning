import asyncio
from websockets import connect
import json
import argparse
import random

async def join_lobby(socket, lobby_name, params={}):
    await socket.send(F'["0", "0", "{lobby_name}", "phx_join", {json.dumps(params)}]')
    message = await socket.recv()
    message = json.loads(message)
    if message[4]["status"] != "ok":
        raise ConnectionError("Failed to join lobby")

async def send_message(socket, lobby_name, type, params={}):
    await socket.send(F'[null, "3", "{lobby_name}", "{type}", {json.dumps(params)}]')
        
async def send():
    async with connect("ws://localhost:5000/socket/websocket?vsn=2.0.0") as websocket:
        await join_lobby(websocket, "room:lobby")
        await send_message(websocket, "room:lobby", "shout",  {"position" : random.randint(0, 100)})

async def receive():
    async with connect("ws://localhost:5000/socket/websocket?vsn=2.0.0") as websocket:
        await join_lobby(websocket, "room:lobby")
        while True:
            message = json.loads(await websocket.recv())
            print(f"Received: {message}")


parser = argparse.ArgumentParser()

parser.add_argument("type", type=str)

args = parser.parse_args()

if args.type == "receiver":
    asyncio.run(receive())
if args.type == "sender":
    asyncio.run(send())