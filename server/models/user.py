from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary
from server.models.base import Base


class User(Base):
    __tablename__ = "users"
    id = Column(TEXT, primary_key=True, index=True)
    name = Column(VARCHAR(100), index=True)
    email = Column(VARCHAR(100), index=True)
    password = Column(LargeBinary, index=True)