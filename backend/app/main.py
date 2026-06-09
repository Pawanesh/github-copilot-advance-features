from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .api import auth, products

app = FastAPI(title="OnlineShopping - Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(products.router, prefix="/api", tags=["products"])


@app.get("/api/health")
async def health():
    return {"status": "ok"}
