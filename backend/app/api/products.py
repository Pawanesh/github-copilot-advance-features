from fastapi import APIRouter, Depends, HTTPException, Header
from pydantic import BaseModel
from typing import List, Optional
from ..db.cosmos_client import get_store
import os
import jwt

router = APIRouter()

JWT_SECRET = os.getenv("JWT_SECRET", "devsecret")


def get_current_user(authorization: Optional[str] = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="missing auth")
    try:
        scheme, token = authorization.split()
        payload = jwt.decode(token, JWT_SECRET, algorithms=["HS256"])
        return payload.get("sub")
    except Exception:
        raise HTTPException(status_code=401, detail="invalid token")


class Product(BaseModel):
    id: str
    name: str
    price: float
    stock: int


@router.get("/inventory/products", response_model=List[Product])
async def list_products():
    store = get_store()
    products = store.list_products()
    return products


class AddCartItem(BaseModel):
    productId: str
    qty: int


@router.post("/cart/items")
async def add_item(item: AddCartItem, user_id: str = Depends(get_current_user)):
    store = get_store()
    prod = store.get_product(item.productId)
    if not prod:
        raise HTTPException(status_code=404, detail="product not found")
    store.add_to_cart(user_id, {"productId": item.productId, "qty": item.qty})
    return {"ok": True}


@router.get("/cart")
async def get_cart(user_id: str = Depends(get_current_user)):
    store = get_store()
    cart = store.get_cart(user_id)
    return cart or {"items": []}


@router.post("/checkout")
async def checkout(user_id: str = Depends(get_current_user)):
    store = get_store()
    order = store.checkout(user_id)
    return {"order": order}
