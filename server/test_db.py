# test_db.py
import sys
import os

# نخلي بايثون يقدر يلاقي فولدر server
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "server"))

from database import get_db
from models.user import User
from sqlalchemy.orm import Session

def main():
    db: Session = next(get_db())
    users = db.query(User).all()
    if not users:
        print("No users found in the database.")
    else:
        for user in users:
            print(f"ID: {user.id}, Name: {user.name}, Email: {user.email}")

if __name__ == "__main__":
    main()
