from fastapi import FastAPI
from server.models.base import Base
from server.routes import auth, song
from server.database import engine

app = FastAPI()

app.include_router(auth.router,prefix='/auth')
app.include_router(song.router,prefix='/song')

Base.metadata.create_all(engine)