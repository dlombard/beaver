from gateways.stripe_client import create_charge


def run_checkout(user_id, amount_cents):
    charge = create_charge(user_id, amount_cents)
    return {"paid": bool(getattr(charge, "paid", False))}
