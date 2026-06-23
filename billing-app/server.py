import os
import sys

# Safely load the .env file for local development.
# If running in Docker/AWS without a .env file, this simply passes silently
# and relies on standard OS environment variables.
try:
    from dotenv import load_dotenv, find_dotenv
    load_dotenv(find_dotenv(), override=True)
except ImportError:
    pass

from app import create_app
from app.consumer import consume_billing_queue

def main():
    print("=" * 60)
    print("💳 BILLING API - Starting RabbitMQ Consumer")
    print("=" * 60)
    
    # Required variables check
    required_vars = [
        'BILLING_DB_NAME',
        'BILLING_DB_USER',
        'BILLING_DB_PASSWORD',
        'BILLING_DB_HOST',
        'BILLING_DB_PORT',
        'RABBITMQ_HOST',
        'RABBITMQ_PORT',
        'RABBITMQ_USER',
        'RABBITMQ_PASSWORD',
        'RABBITMQ_QUEUE'
    ]
    
    print("\n[Startup] Validating environment variables...")
    missing_vars = []
    for var in required_vars:
        value = os.environ.get(var)
        if not value:
            missing_vars.append(var)
            print(f"  ⚠️  {var}: NOT SET (no default)")
        else:
            if 'PASSWORD' in var:
                print(f"  ✅ {var}: ••••••••")
            else:
                print(f"  ✅ {var}: {value}")
    
    if missing_vars:
        print(f"\n[Startup] ⚠️  WARNING: Missing environment variables:")
        for var in missing_vars:
            print(f"  - {var} (no default available)")
    
    print("\n[Startup] Creating Flask application...")
    app = create_app()
    print("[Startup] ✅ Flask app created")
    
    print("\n[Startup] Starting RabbitMQ consumer...")
    print("-" * 60)
    
    try:
        consume_billing_queue(app)
    except KeyboardInterrupt:
        print("\n" + "-" * 60)
        print("[Shutdown] Received keyboard interrupt")
    except Exception as e:
        print(f"\n[Error] Fatal error: {e}")
        import time
        print("Sleeping indefinitely for debugging...")
        while True:
            time.sleep(3600)

if __name__ == '__main__':
    main()