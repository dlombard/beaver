from services.orders_service import create_order


def handle_create_order(request):
    body = request.json
    order = create_order(body["user_id"], body["items"])
    return {"order_id": order["id"], "total_cents": order["total_cents"]}, 201
