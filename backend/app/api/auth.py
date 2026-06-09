from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
import os
import hashlib
import jwt
from ..db.cosmos_client import get_store

router = APIRouter()

JWT_SECRET = os.getenv("JWT_SECRET", "devsecret")


class SignupRequest(BaseModel):
    email: EmailStr
    password: str


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


@router.post("/signup")
async def signup(req: SignupRequest):
    store = get_store()
    existing = store.get_user_by_email(req.email)
    if existing:
        raise HTTPException(status_code=400, detail="user exists")
    password_hash = hashlib.sha256(req.password.encode()).hexdigest()
    user = {"id": req.email, "email": req.email, "passwordHash": password_hash}
    store.upsert_user(user)
    return {"ok": True}


@router.post("/login")
async def login(req: LoginRequest):
    store = get_store()
    user = store.get_user_by_email(req.email)
    if not user:
        raise HTTPException(status_code=401, detail="invalid credentials")
    password_hash = hashlib.sha256(req.password.encode()).hexdigest()
    if password_hash != user.get("passwordHash"):
        raise HTTPException(status_code=401, detail="invalid credentials")
    token = jwt.encode({"sub": user["id"]}, JWT_SECRET, algorithm="HS256")
    return {"access_token": token}
