import unittest
from app import create_app


class SimpleGatewayTest(unittest.TestCase):
    def test_create_app_is_callable(self):
        self.assertTrue(callable(create_app))


if __name__ == '__main__':
    unittest.main()
