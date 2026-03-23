;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; 安装包的步骤：
;;
;;   1. 在此使用 `package!' 语句声明它们，
;;   2. 在 shell 中运行 'doom sync'，
;;   3. 重启 Emacs。
;;
;; 使用 'C-h f package\!' 查看 `package!' 宏的文档。

;; =============================================
;; Termux / Android Mobile Optimizations
;; =============================================

;; 在移动设备上获得更好的终端体验 - 剪贴板集成
(package! clipetty)

;; 用于在软键盘上更轻松组合按键的 Key-chord
(package! key-chord)

;; 从 MELPA、ELPA 或 emacsmirror 安装 SOME-PACKAGE：
;; (package! some-package)

;; 要直接从远程 git 仓库安装包，你必须指定一个 `:recipe'。
;; 你可以在以下链接找到 `:recipe' 接受的参数文档：
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; 如果你尝试安装的包不包含 PACKAGENAME.el 文件，
;; 或者位于仓库的子目录中，你需要在 `:recipe' 中指定 `:files'：
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; 如果你想禁用 Doom 包含的某个包，可以在此处使用 `:disable' 属性：
;; (package! builtin-package :disable t)

;; 你可以覆盖内置包的配方，而无需指定 `:recipe' 的所有属性。
;; 这些将从 Doom 或 MELPA/ELPA/Emacsmirror 继承其余配方：
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; 指定 `:branch' 以从特定分支或标签安装包。
;; 某些包的默认分支不是'master'时需要这样做（我们的包管理器无法处理；
;; 参见 radian-software/straight.el#279）
;; (package! builtin-package :recipe (:branch "develop"))

;; 使用 `:pin' 指定要安装的特定提交。
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom 的包被固定到特定提交，并在版本之间更新。
;; `unpin!' 宏允许你取消固定单个包...
;; (unpin! pinned-package)
;; ...或多个包
;; (unpin! pinned-package another-pinned-package)
;; ...或*所有*包（不推荐；很可能会破坏东西）
;; (unpin! t)
