import os
from typing import Optional, List
import uuid


class InMemoryStore:
    def __init__(self):
        self.users = {}
        self.products = {}
        self.carts = {}
        self.orders = {}
        # seed products
        self.products = {
            "p1": {"id": "p1", "name": "T-Shirt", "price": 19.99, "stock": 100},
            "p2": {"id": "p2", "name": "Mug", "price": 9.5, "stock": 40},
        }

    # users
    def upsert_user(self, user: dict):
        self.users[user["id"]] = user

    def get_user_by_email(self, email: str) -> Optional[dict]:
        return self.users.get(email)

    # products
    def list_products(self) -> List[dict]:
        return list(self.products.values())

    def get_product(self, product_id: str) -> Optional[dict]:
        return self.products.get(product_id)

    # cart
    def add_to_cart(self, user_id: str, item: dict):
        cart = self.carts.setdefault(user_id, {"items": []})
        cart["items"].append(item)

    def get_cart(self, user_id: str) -> Optional[dict]:
        return self.carts.get(user_id)

    def checkout(self, user_id: str) -> dict:
        cart = self.carts.pop(user_id, {"items": []})
        order_id = str(uuid.uuid4())
        order = {"id": order_id, "userId": user_id, "items": cart.get("items", []), "status": "created"}
        self.orders[order_id] = order
        return order


_STORE = InMemoryStore()


def get_store():
    # If COSMOS env is set, a future implementation can return a Cosmos-backed store.
    cosmos_endpoint = os.getenv("COSMOS_ENDPOINT")
    cosmos_key = os.getenv("COSMOS_KEY")
    if cosmos_endpoint and cosmos_key:
        # Placeholder: return Cosmos-backed store (not implemented yet)
        return _STORE
    return _STORE
