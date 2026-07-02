from dataclasses import dataclass, field


@dataclass
class Order:
    id: str
    user_id: str
    items: list = field(default_factory=list)
    total_cents: int = 0
    paid: bool = False
