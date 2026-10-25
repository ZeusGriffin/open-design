/* Z-Firmware v0.1 custom home screen for LILYGO T-Display SF32 + Keyboard.
 * Replaces only app_icon_ui_init() in the official menu_app example.
 * Existing factory pages, radio/GPS/Wi-Fi initialization and battery safety remain.
 */
static void app_icon_ui_init(struct Page *page)
{
    const uint32_t navy = 0x0C1424;
    const uint32_t tile_bg = 0x17243A;
    const uint32_t tile_border = 0x324761;
    const uint32_t accent = 0x6DB9FF;
    lv_obj_t *tiles[APP_SIZE];

    /* Full home canvas, below the untouched 40px factory status bar. */
    lv_obj_t *shell = lv_obj_create(page->root);
    lv_obj_set_size(shell, 480, 440);
    lv_obj_align(shell, LV_ALIGN_TOP_MID, 0, 40);
    lv_obj_set_scrollbar_mode(shell, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_scroll_dir(shell, LV_DIR_NONE);
    lv_obj_set_style_pad_all(shell, 0, 0);
    lv_obj_set_style_radius(shell, 0, 0);
    lv_obj_set_style_border_width(shell, 0, 0);
    lv_obj_set_style_bg_color(shell, lv_color_hex(navy), 0);
    lv_obj_set_style_bg_opa(shell, LV_OPA_COVER, 0);

    lv_obj_t *brand = lv_label_create(shell);
    lv_label_set_text(brand, "Z-FIRMWARE");
    lv_obj_align(brand, LV_ALIGN_TOP_LEFT, 18, 12);
    lv_obj_set_style_text_font(brand, &lv_font_montserrat_24, 0);
    lv_obj_set_style_text_color(brand, lv_color_hex(0xFFFFFF), 0);

    lv_obj_t *version = lv_label_create(shell);
    lv_label_set_text(version, "SF32 / v0.1");
    lv_obj_align(version, LV_ALIGN_TOP_RIGHT, -16, 20);
    lv_obj_set_style_text_font(version, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(version, lv_color_hex(accent), 0);

    lv_obj_t *hint = lv_label_create(shell);
    lv_label_set_text(hint, "TOOLS  /  SELECT WITH TOUCH OR KEYS");
    lv_obj_align(hint, LV_ALIGN_TOP_LEFT, 18, 51);
    lv_obj_set_style_text_font(hint, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(hint, lv_color_hex(0xA5B6CD), 0);

    /* Keep the original app IDs and click handler for all eleven apps. */
    lv_obj_t *grid = lv_obj_create(shell);
    lv_obj_set_size(grid, 456, 350);
    lv_obj_align(grid, LV_ALIGN_TOP_MID, 0, 84);
    lv_obj_set_style_bg_opa(grid, LV_OPA_0, 0);
    lv_obj_set_style_border_width(grid, 0, 0);
    lv_obj_set_style_radius(grid, 0, 0);
    lv_obj_set_style_pad_all(grid, 6, 0);
    lv_obj_set_style_pad_row(grid, 10, 0);
    lv_obj_set_style_pad_column(grid, 10, 0);
    lv_obj_set_flex_flow(grid, LV_FLEX_FLOW_ROW_WRAP);
    lv_obj_set_flex_align(grid, LV_FLEX_ALIGN_START,
                          LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_START);
    lv_obj_set_scroll_dir(grid, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(grid, LV_SCROLLBAR_MODE_AUTO);
    lv_obj_add_flag(grid, LV_OBJ_FLAG_SCROLLABLE);

    for (int i = 0; i < APP_SIZE; ++i)
    {
        lv_obj_t *tile = lv_button_create(grid);
        tiles[i] = tile;
        lv_obj_set_size(tile, 208, 100);
        lv_obj_set_style_radius(tile, 14, 0);
        lv_obj_set_style_bg_color(tile, lv_color_hex(tile_bg), 0);
        lv_obj_set_style_bg_opa(tile, LV_OPA_COVER, 0);
        lv_obj_set_style_border_width(tile, 1, 0);
        lv_obj_set_style_border_color(tile, lv_color_hex(tile_border), 0);
        lv_obj_set_style_shadow_width(tile, 0, 0);
        lv_obj_set_style_outline_width(tile, 2, LV_STATE_FOCUSED);
        lv_obj_set_style_outline_color(tile, lv_color_hex(accent), LV_STATE_FOCUSED);
        lv_obj_set_style_pad_all(tile, 0, 0);
        lv_obj_add_flag(tile, LV_OBJ_FLAG_SCROLL_ON_FOCUS);
        lv_obj_set_user_data(tile, (void *)(intptr_t)app_list[i].id);
        lv_obj_add_event_cb(tile, app_icon_event_cb, LV_EVENT_CLICKED, NULL);
        lv_group_add_obj(page->group, tile);

        /* Simple lightweight monogram instead of adding extra image assets. */
        lv_obj_t *letter = lv_label_create(tile);
        char monogram[2] = {app_list[i].name[0], '\0'};
        lv_label_set_text(letter, monogram);
        lv_obj_align(letter, LV_ALIGN_LEFT_MID, 17, 0);
        lv_obj_set_style_text_font(letter, &lv_font_montserrat_36, 0);
        lv_obj_set_style_text_color(letter, lv_color_hex(accent), 0);

        lv_obj_t *title = lv_label_create(tile);
        lv_label_set_text(title, app_list[i].name);
        lv_obj_set_width(title, 135);
        lv_obj_align(title, LV_ALIGN_LEFT_MID, 62, -6);
        lv_obj_set_style_text_font(title, &lv_font_montserrat_20, 0);
        lv_obj_set_style_text_color(title, lv_color_hex(0xFFFFFF), 0);
        lv_label_set_long_mode(title, LV_LABEL_LONG_DOT);

        lv_obj_t *number = lv_label_create(tile);
        lv_label_set_text_fmt(number, "APP %02d", i + 1);
        lv_obj_align(number, LV_ALIGN_LEFT_MID, 63, 26);
        lv_obj_set_style_text_font(number, &lv_font_montserrat_16, 0);
        lv_obj_set_style_text_color(number, lv_color_hex(0x98AAC0), 0);
    }

    if (last_page && last_page->id != PAGE_START &&
        last_page->app_id < APP_SIZE)
    {
        lv_group_focus_obj(tiles[last_page->app_id]);
        lv_obj_scroll_to_view(tiles[last_page->app_id], LV_ANIM_OFF);
    }
    else if (APP_SIZE > 0)
    {
        lv_group_focus_obj(tiles[0]);
    }
}
