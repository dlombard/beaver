from services.orders_service import mark_paid
from use_cases.checkout import run_checkout


def charge_for_order(order):
    result = run_checkout(order.user_id, order.total_cents)
    if result["paid"]:
        mark_paid(order.id)
    return result
