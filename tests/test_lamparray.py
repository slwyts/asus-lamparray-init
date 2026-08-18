import importlib.machinery
import importlib.util
import struct
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "asus-lamparray-init"
loader = importlib.machinery.SourceFileLoader("lamparray", str(SCRIPT))
spec = importlib.util.spec_from_loader(loader.name, loader)
lamparray = importlib.util.module_from_spec(spec)
loader.exec_module(lamparray)


class LampArrayTests(unittest.TestCase):
    def test_parse_color(self):
        self.assertEqual(lamparray.parse_color("#0066ff"), (0, 102, 255))

    def test_parse_color_rejects_invalid_input(self):
        with self.assertRaises(ValueError):
            lamparray.parse_color("red")

    def test_range_update_payload(self):
        payload = lamparray.build_range_update(1, (255, 0, 0), 128)
        self.assertEqual(payload, struct.pack("<BBHHBBBB", 0x45, 1, 0, 0, 255, 0, 0, 128))

    def test_range_update_rejects_zero_lamps(self):
        with self.assertRaises(lamparray.LampArrayError):
            lamparray.build_range_update(0, (255, 255, 255), 255)


if __name__ == "__main__":
    unittest.main()
