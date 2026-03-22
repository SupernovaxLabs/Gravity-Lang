#pragma once
// ── Windows UTF-8 console setup ───────────────────────────────────────────────
// Include this header inside the tui namespace after the platform includes.
// Calling tui::win32_enable_utf8_console() at the start of main() ensures that:
//   1. The console output code page is set to UTF-8 (CP_UTF8 / 65001) so that
//      box-drawing and other multibyte Unicode characters render correctly.
//   2. Virtual Terminal Processing is enabled on both stdout and stderr so that
//      ANSI escape sequences for colours and bold text are honoured on
//      Windows 10 version 1511 and later.
#ifdef _WIN32
    inline void win32_enable_utf8_console() {
        SetConsoleOutputCP(CP_UTF8);
        auto enable_vt = [](DWORD handle_id) {
            HANDLE h = GetStdHandle(handle_id);
            if (h == INVALID_HANDLE_VALUE) return;
            DWORD mode = 0;
            if (GetConsoleMode(h, &mode))
                SetConsoleMode(h, mode | ENABLE_VIRTUAL_TERMINAL_PROCESSING);
        };
        enable_vt(STD_OUTPUT_HANDLE);
        enable_vt(STD_ERROR_HANDLE);
    }
#endif
