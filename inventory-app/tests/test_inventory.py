import os
import unittest

# Set dummy environment variables to prevent KeyError on import of app.db
os.environ['INVENTORY_DB_USER'] = 'dummy'
os.environ['INVENTORY_DB_PASSWORD'] = 'dummy'
os.environ['INVENTORY_DB_HOST'] = 'localhost'
os.environ['INVENTORY_DB_PORT'] = '5432'
os.environ['INVENTORY_DB_NAME'] = 'dummy'

from app.models import Movie


class SimpleInventoryTest(unittest.TestCase):
    def test_movie_model_instantiation(self):
        movie = Movie(
            title="Inception",
            genre="Sci-Fi",
            release_year=2010,
            rating=8.8
        )
        self.assertEqual(movie.title, "Inception")
        self.assertEqual(movie.genre, "Sci-Fi")
        self.assertEqual(movie.release_year, 2010)
        self.assertEqual(movie.rating, 8.8)

    def test_movie_to_dict(self):
        movie = Movie(
            title="Memento",
            genre="Thriller"
        )
        movie_dict = movie.to_dict()
        self.assertEqual(movie_dict['title'], "Memento")
        self.assertEqual(movie_dict['genre'], "Thriller")


if __name__ == '__main__':
    unittest.main()
