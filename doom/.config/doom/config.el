;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; 在此放置你的私人配置！记住，修改此文件后无需运行 'doom sync'！

;; =============================================
;; 国内镜像源配置 (China Mirror Configuration)
;; =============================================
;; 配置 Emacs 包管理器使用国内镜像，加速安装和更新

;; 配置 ELPA 国内镜像 (清华大学)
(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("org"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

;; 配置 Straight 使用国内 Git 镜像 (通过环境变量)
;; 可以在 shell 中设置以下环境变量来加速:
;; export HTTPS_PROXY=your_proxy (如果需要代理)
;; 或者使用镜像站点

;; =============================================
;; Termux / Android Mobile Optimizations
;; =============================================

;; -----------------------------------------
;; 0. Shell Configuration (for Fish compatibility)
;; -----------------------------------------
;; Use bash for internal Emacs operations (POSIX compliant)
(setq shell-file-name (executable-find "bash"))

;; -----------------------------------------
;; 1. Touch Screen Support
;; -----------------------------------------
;; 启用鼠标支持 (在终端中模拟触摸)
;; Emacs 29+ 内置了 touch-screen 支持，在图形界面会自动启用

;; Enable mouse support in terminal (for touch)
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-1>") 'mouse-set-point)
  (global-set-key (kbd "<mouse-2>") 'mouse-yank-primary)
  (global-set-key (kbd "<mouse-3>") 'mouse-save-then-kill))

;; -----------------------------------------
;; 2. Font & UI Scaling for Mobile
;; -----------------------------------------
;; Larger font for small mobile screens
(setq doom-font (font-spec :family "monospace" :size 16)
      doom-variable-pitch-font (font-spec :family "sans-serif" :size 16)
      doom-big-font (font-spec :family "monospace" :size 20))

;; Disable line numbers on mobile (save screen space)
(setq display-line-numbers-type nil)

;; Show cursor line for better visibility
(global-hl-line-mode 1)

;; -----------------------------------------
;; 3. Soft Keyboard & Input Optimizations
;; -----------------------------------------
;; Disable the C-i ambiguity (important for soft keyboards)
(setq evil-want-C-i-jump nil)

;; Use shorter escape sequences for soft keyboards
(setq evil-esc-delay 0.01)

;; Enable key-chord for easier key combinations on soft keyboard
(after! evil
  (use-package! key-chord
    :config
    (key-chord-mode 1)
    ;; Quick escape with 'jk' or 'jj' (easier on soft keyboard)
    (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
    (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)))

;; -----------------------------------------
;; 4. Evil Mode Mobile Optimizations
;; -----------------------------------------
;; Use C-[ as escape (easier on mobile)
(define-key key-translation-map (kbd "C-[") (kbd "<escape>"))

;; Single key shortcuts for common operations
(map! :leader
      :desc "Save file" "w" #'save-buffer
      :desc "Quit" "q" #'kill-current-buffer
      :desc "Find file" "f" #'find-file
      :desc "Recent files" "r" #'recentf-open-files)

;; -----------------------------------------
;; 5. File Navigation Optimizations
;; -----------------------------------------
;; Use simpler file browser for mobile
(setq dired-listing-switches "-alh")

;; Enable dired-omit-mode to hide dotfiles by default
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; Quick file navigation
(map! :leader
      :desc "Dired" "d" #'dired
      :desc "Dired jump" "j" #'dired-jump)

;; -----------------------------------------
;; 6. Performance Optimizations for Mobile
;; -----------------------------------------
;; Reduce garbage collection frequency during startup
(setq gc-cons-threshold (* 100 1024 1024)) ; 100MB

;; Lower threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)))) ; 16MB

;; Disable bidirectional text scanning for performance
(setq bidi-inhibit-bpa t)

;; Disable cursor blinking (saves battery)
(blink-cursor-mode -1)

;; Disable auto-save and backup to reduce disk I/O on mobile
(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil)

;; -----------------------------------------
;; 7. Terminal & Clipboard Integration
;; -----------------------------------------
;; Use clipetty for better clipboard integration with Termux
(use-package! clipetty
  :config
  (global-clipetty-mode))

;; Ensure clipboard works in terminal
(setq select-enable-clipboard t
      select-enable-primary t)

;; -----------------------------------------
;; 8. Touch-friendly Keybindings
;; -----------------------------------------
;; Swipe-like navigation with arrow keys
(map! :nvi "<left>" #'backward-char
      :nvi "<right>" #'forward-char
      :nvi "<up>" #'previous-line
      :nvi "<down>" #'next-line)

;; Easy window navigation
(map! :leader
      :desc "Window left" "h" #'windmove-left
      :desc "Window right" "l" #'windmove-right
      :desc "Window up" "k" #'windmove-up
      :desc "Window down" "j" #'windmove-down)

;; -----------------------------------------
;; 9. Org Mode Mobile Optimizations
;; -----------------------------------------
;; Mobile-friendly org settings
(setq org-startup-folded 'content
      org-cycle-separator-lines 1
      org-hide-leading-stars t
      org-indent-indentation-per-level 1)

;; Quick org capture
(map! :leader
      :desc "Org capture" "c" #'org-capture)

;; -----------------------------------------
;; 10. Theme & Visual Comfort
;; -----------------------------------------
;; Use a comfortable theme for mobile
(setq doom-theme 'doom-one)

;; Disable fancy UI elements that may not render well on mobile
(setq doom-themes-enable-bold t
      doom-themes-enable-italic nil)

;; =============================================
;; End of Mobile Optimizations
;; =============================================


;; 某些功能使用此信息来识别你，例如 GPG 配置、电子邮件客户端、文件模板和代码片段。这是可选的。
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom 提供了五个（可选的）变量来控制字体：
;;
;; - `doom-font' -- 主要使用的字体
;; - `doom-variable-pitch-font' -- 非等宽字体（在适用的地方）
;; - `doom-big-font' -- 用于 `doom-big-font-mode'；可用于演示或直播
;; - `doom-symbol-font' -- 用于符号
;; - `doom-serif-font' -- 用于 `fixed-pitch-serif' 字体样式
;;
;; 查看 'C-h v doom-font' 获取文档和更多示例。例如：
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; 如果你或 Emacs 找不到字体，使用 'M-x describe-font' 来查找，
;; 使用 `M-x eval-region' 执行 elisp 代码，使用 'M-x doom/reload-font' 刷新字体设置。
;; 如果 Emacs 仍然找不到字体，很可能是没有正确安装。字体问题很少是 Doom 的问题！

;; 加载主题有两种方式。两者都假设主题已安装且可用。
;; 你可以设置 `doom-theme' 或使用 `load-theme' 函数手动加载主题。这是默认值：
(setq doom-theme 'doom-one)

;; 这决定了行号的显示样式。如果设置为 `nil'，则禁用行号。
;; 如需相对行号，请将此设置为 `relative'。
(setq display-line-numbers-type t)

;; 如果你使用 `org' 且不希望将 org 文件放在下面的默认位置，
;; 请更改 `org-directory'。必须在 org 加载之前设置！
(setq org-directory "~/org/")


;; 每当你重新配置一个包时，确保将你的配置包装在
;; `with-eval-after-load' 块中，否则 Doom 的默认值可能会覆盖你的设置。例如：
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; 此规则的例外情况：
;;
;;   - 设置文件/目录变量（如 `org-directory'）
;;   - 设置那些明确告诉你要在包加载之前设置的变量（查看 'C-h v VARIABLE' 来查找它们）
;;   - 设置 doom 变量（以 'doom-' 或 '+' 开头的）
;;
;; 以下是一些额外的函数/宏，可帮助你配置 Doom：
;;
;; - `load!' 用于加载相对于此文件的外部 *.el 文件
;; - `add-load-path!' 用于将目录添加到 `load-path'，相对于此文件。
;;   Emacs 在使用 `require' 或 `use-package' 加载包时会搜索 `load-path'。
;; - `map!' 用于绑定新按键
;;
;; 要获取这些函数/宏的信息，将光标移到高亮符号上并按 'K'（非 evil 用户需按 'C-c c k'）。
;; 这将打开其文档，包括使用示例。
;; 或者，使用 `C-h o' 查找符号（函数、变量、字体样式等）。
;;
;; 你也可以尝试 'gd'（或 'C-c c d'）跳转到它们的定义，查看它们的实现方式。
