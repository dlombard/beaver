import unittest

import app


class CreateTaskTests(unittest.TestCase):
    def setUp(self):
        app.TASKS.clear()

    def test_create(self):
        status, task = app.create_task({"title": "a"})
        self.assertEqual(status, 201)
        self.assertEqual(task["title"], "a")

    def test_empty_title(self):
        status, body = app.create_task({"title": ""})
        self.assertEqual(status, 400)


if __name__ == "__main__":
    unittest.main()
