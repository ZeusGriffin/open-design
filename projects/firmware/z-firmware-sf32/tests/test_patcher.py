import sys
import tempfile
import unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from apply_z import apply, START, END


class PatcherTest(unittest.TestCase):
    def setUp(self):
        self.ctx = tempfile.TemporaryDirectory()
        self.addCleanup(self.ctx.cleanup)
        self.root = Path(self.ctx.name)
        self.target = self.root / 'examples/menu_app/src/ui.c'
        self.target.parent.mkdir(parents=True)
        self.patch = Path(__file__).resolve().parents[1] / 'patches/z_launcher_home.c'

    def test_happy_path_and_idempotence(self):
        original = 'PREFIX\n' + START + '\n  OLD MENU\n}\n\n' + END + '\nKEEP\n'
        self.target.write_text(original)
        result = apply(self.root, self.patch)
        self.assertIn('patched', result)
        self.assertEqual(self.target.with_suffix('.c.z-original-backup').read_text(), original)
        new = self.target.read_text()
        self.assertIn('Z-FIRMWARE', new)
        self.assertTrue(new.startswith('PREFIX\n'))
        self.assertTrue(new.endswith(END + '\nKEEP\n'))
        self.assertIn('already applied', apply(self.root, self.patch))

    def test_rejects_unknown_layout_without_write(self):
        self.target.write_text('unexpected UI source')
        with self.assertRaises(ValueError):
            apply(self.root, self.patch)
        self.assertEqual(self.target.read_text(), 'unexpected UI source')
        self.assertFalse(self.target.with_suffix('.c.z-original-backup').exists())

    def test_preserves_factory_navigation_and_battery_logic(self):
        content = self.patch.read_text()
        self.assertIn('app_icon_event_cb', content)
        self.assertIn('lv_group_add_obj(page->group, tile)', content)
        self.assertNotIn('flash', content.lower().split('static void app_icon_ui_init')[1])


if __name__ == '__main__':
    unittest.main()
