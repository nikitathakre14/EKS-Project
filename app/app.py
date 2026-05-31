from pathlib import Path
from typing import List

from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

BASE_DIR = Path(__file__).resolve().parent
UI_DIR = BASE_DIR / "ui"

app = FastAPI(
    title="eks-portal",
    description="Single Python application that serves the UI and both user and order APIs.",
    version="1.0.0",
)

app.mount("/static", StaticFiles(directory=UI_DIR), name="static")

@app.get("/", response_class=FileResponse, tags=["ui"], summary="Serve application UI")
def ui_index():
    return UI_DIR / "index.html"

class User(BaseModel):
    id: int
    name: str
    email: str

class Order(BaseModel):
    id: int
    user_id: int
    product: str
    quantity: int

users: List[User] = [
    User(id=1, name="Alice", email="alice@example.com"),
    User(id=2, name="Bob", email="bob@example.com"),
]

orders: List[Order] = [
    Order(id=1, user_id=1, product="Coffee Beans", quantity=2),
    Order(id=2, user_id=2, product="Notebook", quantity=5),
]

@app.get("/user", tags=["service"], summary="User service info")
def user_info():
    return {
        "service": "user-service",
        "status": "ok",
        "message": "User service is available.",
        "endpoints": ["/user", "/user/ping", "/user/users"],
    }

@app.get("/user/ping", tags=["service"], summary="User health check")
def user_ping():
    return {"service": "user-service", "status": "healthy"}

@app.get("/user/users", response_model=List[User], tags=["users"], summary="List users")
def list_users():
    return users

@app.get("/user/users/{user_id}", response_model=User, tags=["users"], summary="Get user by ID")
def get_user(user_id: int):
    for user in users:
        if user.id == user_id:
            return user
    raise HTTPException(status_code=404, detail="User not found")

@app.post("/user/users", response_model=User, tags=["users"], summary="Create a new user")
def create_user(payload: User):
    if any(user.id == payload.id for user in users):
        raise HTTPException(status_code=400, detail="User with this ID already exists")
    users.append(payload)
    return payload

@app.get("/order", tags=["service"], summary="Order service info")
def order_info():
    return {
        "service": "order-service",
        "status": "ok",
        "message": "Order service is available.",
        "endpoints": ["/order", "/order/ping", "/order/orders"],
    }

@app.get("/order/ping", tags=["service"], summary="Order health check")
def order_ping():
    return {"service": "order-service", "status": "healthy"}

@app.get("/order/orders", response_model=List[Order], tags=["orders"], summary="List orders")
def list_orders():
    return orders

@app.get("/order/orders/{order_id}", response_model=Order, tags=["orders"], summary="Get order by ID")
def get_order(order_id: int):
    for order in orders:
        if order.id == order_id:
            return order
    raise HTTPException(status_code=404, detail="Order not found")

@app.post("/order/orders", response_model=Order, tags=["orders"], summary="Create a new order")
def create_order(payload: Order):
    if any(order.id == payload.id for order in orders):
        raise HTTPException(status_code=400, detail="Order with this ID already exists")
    orders.append(payload)
    return payload
