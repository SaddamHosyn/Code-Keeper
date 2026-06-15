import os
from flask_sqlalchemy import SQLAlchemy

# Safely get variables with fallback defaults. 
# In production, these come from AWS/Docker. Locally, they come from the .env file.
db_user = os.environ.get('BILLING_DB_USER', 'billinguser')
db_password = os.environ.get('BILLING_DB_PASSWORD', 'password')
db_host = os.environ.get('BILLING_DB_HOST', 'localhost')
db_port = os.environ.get('BILLING_DB_PORT', '5432')
db_name = os.environ.get('BILLING_DB_NAME', 'billing')

DATABASE_URI = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

db = SQLAlchemy()