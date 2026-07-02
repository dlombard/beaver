import uuid

from models.order import Order
from services.billing_service import charge_for_order


def create_order(user_id, items):
    total = sum(i["price_cents"] for i in items)
    order = Order(id=uuid.uuid4().hex, user_id=user_id, items=items, total_cents=total)
    charge_for_order(order)
    return {"id": order.id, "total_cents": order.total_cents}


def mark_paid(order_id):
    # persist paid=True for order_id
    return True
