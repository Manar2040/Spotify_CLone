import sys
import os
import uuid

# Add server directory to path so imports work
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

from server.database import get_db
from server.models.song import Song
from sqlalchemy.orm import Session

def seed_songs():
    # Get database session
    db: Session = next(get_db())
    
    # Clear existing songs to replace bad URLs
    db.query(Song).delete()
    db.commit()
    print("Cleared existing songs.")

    print("Seeding test songs with reliable URLs...")

    test_songs = [
        Song(
            id=str(uuid.uuid4()),
            song_name="Song 1",
            artist="SoundHelix",
            hex_code="FF5733",
            song_url="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
            thumbnail_url="https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bXVzaWN8ZW58MHx8MHx8fDA%3D"
        ),
        Song(
            id=str(uuid.uuid4()),
            song_name="Song 2",
            artist="SoundHelix",
            hex_code="33FF57",
            song_url="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
            thumbnail_url="https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8bXVzaWN8ZW58MHx8MHx8fDA%3D"
        ),
        Song(
            id=str(uuid.uuid4()),
            song_name="Song 3",
            artist="SoundHelix",
            hex_code="3357FF",
            song_url="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
            thumbnail_url="https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fG11c2ljfGVufDB8fDB8fHww"
        ),
        Song(
            id=str(uuid.uuid4()),
            song_name="Song 4",
            artist="SoundHelix",
            hex_code="FF33A8",
            song_url="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
            thumbnail_url="https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bXVzaWN8ZW58MHx8MHx8fDA%3D"
        ),
    ]

    for song in test_songs:
        db.add(song)
    
    db.commit()
    print(f"Successfully added {len(test_songs)} test songs!")

if __name__ == "__main__":
    seed_songs()
