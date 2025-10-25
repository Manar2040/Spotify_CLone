from fastapi import FastAPI
from pydantic import BaseModel
from sqlalchemy import create_engine, TEXT, String, Column, LargeBinary, VARCHAR
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import uuid
import bcrypt

app = FastAPI()

DATABASE_URL = "postgresql://postgres:192003@localhost:5432/fluttermusicapp"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

db = SessionLocal()

class UserCreate(BaseModel):
     name: str
     email: str
     password: str

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(TEXT, primary_key=True, index=True)
    name = Column(VARCHAR(100), index=True)
    email = Column(VARCHAR(100), index=True)
    password = Column(LargeBinary, index=True)

@app.post("/signup")
def signup_user(user: UserCreate):
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(status_code=400, detail="User already exists")
    
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db


Base.metadata.create_all(engine)