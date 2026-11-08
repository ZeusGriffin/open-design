"""Nominal standard iPhone 15 dimensions, millimeters.
Design inputs only; not a validated printable enclosure.
"""
from dataclasses import dataclass

@dataclass(frozen=True)
class PhoneSpec:
    name: str = "iPhone 15"
    height_mm: float = 147.6
    width_mm: float = 71.6
    thickness_mm: float = 7.8
    clearance_per_side_mm: float = 0.6
    tray_wall_mm: float = 2.0

    @property
    def cavity_width_mm(self):
        return self.width_mm + 2 * self.clearance_per_side_mm

    @property
    def cavity_height_mm(self):
        return self.height_mm + 2 * self.clearance_per_side_mm

    @property
    def outer_width_mm(self):
        return self.cavity_width_mm + 2 * self.tray_wall_mm

    @property
    def outer_height_mm(self):
        return self.cavity_height_mm + 2 * self.tray_wall_mm

if __name__ == "__main__":
    p = PhoneSpec()
    print(p)
    print("Cavity (mm):", p.cavity_width_mm, p.cavity_height_mm)
    print("Outer footprint (mm):", p.outer_width_mm, p.outer_height_mm)
