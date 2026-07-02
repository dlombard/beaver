import os

import stripe  # third-party provider SDK

stripe.api_key = os.environ.get("STRIPE_KEY", "")


def create_charge(customer_id, amount_cents):
    return stripe.Charge.create(
        amount=amount_cents, currency="usd", customer=customer_id
    )
