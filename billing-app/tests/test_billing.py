import os
import unittest

# Set dummy environment variables to prevent KeyError on import of app.db
os.environ['BILLING_DB_USER'] = 'dummy'
os.environ['BILLING_DB_PASSWORD'] = 'dummy'
os.environ['BILLING_DB_HOST'] = 'localhost'
os.environ['BILLING_DB_PORT'] = '5432'
os.environ['BILLING_DB_NAME'] = 'dummy'

from app.models import Order


class SimpleBillingTest(unittest.TestCase):
    def test_order_model_instantiation(self):
        order = Order(
            user_id="user_123",
            number_of_items="3",
            total_amount="45.50"
        )
        self.assertEqual(order.user_id, "user_123")
        self.assertEqual(order.number_of_items, "3")
        self.assertEqual(order.total_amount, "45.50")

    def test_order_to_dict(self):
        order = Order(
            user_id="user_999",
            number_of_items="1",
            total_amount="10.00"
        )
        order_dict = order.to_dict()
        self.assertEqual(order_dict['user_id'], "user_999")
        self.assertEqual(order_dict['total_amount'], "10.00")


if __name__ == '__main__':
    unittest.main()
