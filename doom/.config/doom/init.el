;;; init.el -*- lexical-binding: t; -*-

;; 此文件控制哪些 Doom 模块被启用以及它们的加载顺序。
;; 修改后记得运行 'doom sync'！

;; 注意：按 'SPC h d h'（非 vim 用户按 'C-h d h'）访问 Doom 的
;;   文档。在那里你会找到 Doom 模块索引的链接，其中列出了所有
;;   模块及其支持的标志。

;; 注意：将光标移到模块名称（或其标志）上并按 'K'（非 vim 用户按
;;   'C-c c k'）查看其文档。这也适用于标志（那些以加号开头的符号）。
;;
;;   或者，在模块上按 'gd'（或 'C-c c d'）浏览其目录（方便访问源代码）。

(doom! :input
       ;;bidi              ; (tfel ot) thgir etirw uoy gnipleh
       ;;chinese
       ;;japanese
       ;;layout            ; auie,ctsrnm is the superior home row

       :completion
       ;;company           ; 终极代码补全后端
       (corfu +orderless)  ; 使用 cap(f)、cape 和飞羽完成补全！
       ;;helm              ; 另一个用于热爱和生活的搜索引擎
       ;;ido               ; 另一个*另一个*搜索引擎...
       ;;ivy               ; 用于热爱和生活的搜索引擎
       vertico           ; 未来的搜索引擎

       :ui
       ;;deft              ; Emacs 的 notational velocity
       doom              ; 让 DOOM 看起来如此的原因
       dashboard         ; Emacs 的精美启动画面
       ;;doom-quit         ; 退出 Emacs 时显示 DOOM 退出消息提示
       ;;(emoji +unicode)  ; 🙂
       hl-todo           ; 高亮 TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       ;;indent-guides     ; 高亮缩进列
       ;;ligatures         ; 连字和符号，让你的代码再次美观
       ;;minimap           ; 在侧边显示代码地图
       modeline          ; 时髦的、受 Atom 启发的状态栏，外加 API
       ;;nav-flash         ; 大幅移动后闪烁光标行
       ;;neotree           ; 项目抽屉，类似 vim 的 NERDTree
       ophints           ; 高亮操作作用的区域
       (popup +defaults)   ; 驯服突然但不可避免的临时窗口
       ;;smooth-scroll     ; 如此流畅，你会不敢相信它不是黄油
       ;;tabs              ; Emacs 的标签栏
       ;;treemacs          ; 项目抽屉，比 neotree 更酷
       ;;unicode           ; 为各种语言提供扩展的 unicode 支持
       (vc-gutter +pretty) ; 在边缘显示版本控制差异
       vi-tilde-fringe   ; 用边缘波浪号标记缓冲区末尾之外
       ;;window-select     ; 可视化切换窗口
       workspaces        ; 标签模拟、持久化和独立工作区
       ;;zen               ; 无干扰的编码或写作

       :editor
       (evil +everywhere); 来到黑暗面，我们有饼干
       file-templates    ; 空文件的自动代码片段
       fold              ; （几乎）通用的代码折叠
       ;;(format +onsave)  ; 自动美化
       ;;god               ; 无需修饰键运行 Emacs 命令
       ;;lispy             ; 给不喜欢 vim 的人用的 vim for lisp
       ;;multiple-cursors  ; 同时在多处编辑
       ;;objed             ; 为新手提供的文本对象编辑
       ;;parinfer          ; 把 lisp 变成 python，差不多
       ;;rotate-text       ; 在光标处的文本候选之间循环
       snippets          ; 我的小精灵。它们帮我打字，这样我就不用打了
       (whitespace +guess +trim)  ; 你的空白字符管家
       ;;word-wrap         ; 带有语言感知缩进的软换行

       :emacs
       dired             ; 让 dired 美观[实用]
       electric          ; 更智能的、基于关键字的光标自动缩进
       ;;eww               ; 互联网很糟糕
       ;;ibuffer           ; 交互式缓冲区管理
       tramp             ; 用你关节炎的手指操作远程文件
       undo              ; 为你不可避免的错误提供持久、更智能的撤销
       vc                ; 版本控制和 Emacs，坐在树上

       :term
       ;;eshell            ; 到处都能用的 elisp shell
       ;;shell             ; Emacs 的简单 shell REPL
       ;;term              ; Emacs 的基础终端模拟器
       ;;vterm             ; Emacs 中最好的终端模拟

       :checkers
       syntax              ; 为你忘记的每个分号而电击你
       ;;(spell +flyspell) ; 为你拼写错误"mispelling"而电击你
       ;;grammar           ; 为你犯的每个语法错误而电击你

       :tools
       ;;ansible
       ;;biblio            ; 为你写博士论文（需要引用）
       ;;collab            ; 与朋友共享缓冲区
       ;;debugger          ; 逐步执行代码，帮你添加 bug
       ;;direnv
       ;;docker
       ;;editorconfig      ; 让别人去争论制表符 vs 空格
       ;;ein               ; 用 emacs 驯服 Jupyter 笔记本
       (eval +overlay)     ; 运行代码，运行（还有 repls）
       lookup              ; 浏览你的代码及其文档
       ;;llm               ; 当我说你需要朋友时，我不是指...
       ;;(lsp +eglot)      ; M-x vscode
       magit             ; Emacs 的 git 瓷器
       ;;make              ; 从 Emacs 运行 make 任务
       ;;pass              ; 极客的密码管理器
       ;;pdf               ; pdf 增强
       ;;terraform         ; 基础设施即代码
       ;;tmux              ; 与 tmux 交互的 API
       ;;tree-sitter       ; 语法和解析，坐在树上...
       ;;upload            ; 通过 ssh/ftp 将本地映射到远程项目

       :os
       (:if (featurep :system 'macos) macos)  ; 提高与 macOS 的兼容性
       tty               ; 改善终端 Emacs 体验（对 Termux 至关重要）

       :lang
       ;;ada               ; 我们（盲目地）信任强类型
       ;;(agda +local)     ; 类型的类型的类型的类型...
       ;;beancount         ; 注意 GAAP
       ;;(cc +lsp)         ; C > C++ == 1
       ;;clojure           ; 带 lisp 的 java
       ;;common-lisp       ; 如果你见过一个 lisp，你就见过所有 lisp
       ;;coq               ; 证明即程序
       ;;crystal           ; 以 c 的速度运行的 ruby
       ;;csharp            ; unity、.NET 和 mono 的恶作剧
       ;;data              ; 配置/数据格式
       ;;(dart +flutter)   ; 绘制 ui，其他不多
       ;;dhall
       ;;elixir            ; 正确实现的 erlang
       ;;elm               ; 想来杯 TEA 吗？
       emacs-lisp        ; 淹没在括号中
       ;;erlang            ; 一个更文明时代的优雅语言
       ;;ess               ; emacs 说统计
       ;;factor
       ;;faust             ; dsp，但你可以保留你的灵魂
       ;;fortran           ; 在 FORTRAN 中，上帝是真实的（除非声明为 INTEGER）
       ;;fsharp            ; ML 代表微软的语言
       ;;fstar             ; （依赖）类型和（单子）效果以及 Z3
       ;;gdscript          ; 你等待的语言
       ;;(go +lsp)         ; 潮人方言
       ;;(graphql +lsp)    ; 让查询休息一下
       ;;(haskell +lsp)    ; 一种比我更懒的语言
       ;;hy                ; scheme 的可读性 + python 的速度
       ;;idris             ; 一种你可以依赖的语言
       ;;json              ; 至少它不是 XML
       ;;janet             ; 有趣的事实：Janet 就是我！
       ;;(java +lsp)       ; 腕管综合征的典型代表
       ;;javascript        ; all(hope(abandon(ye(who(enter(here))))))
       ;;julia             ; 更好、更快的 MATLAB
       ;;kotlin            ; 更好、更流畅的 Java(Script)
       ;;latex             ; 在 Emacs 中写论文从未如此有趣
       ;;lean              ; 为有太多东西要证明的人准备
       ;;ledger            ; 尽你所能审计
       ;;lua               ; 从 1 开始的索引？从 1 开始的索引
       markdown          ; 写文档给人们忽略
       ;;nim               ; python + lisp，以 c 的速度运行
       ;;nix               ; 我在此宣布"nix geht mehr！"
       ;;ocaml             ; 一个客观的骆驼
       org               ; 用纯文本组织你的平凡生活
       ;;php               ; perl 的不安全弟弟
       ;;plantuml          ; 让人更困惑的图表
       ;;graphviz          ; 让你自己更困惑的图表
       ;;purescript        ; javascript，但是函数式
       ;;python            ; 美丽胜于丑陋
       ;;qt                ; 有史以来"最可爱"的 gui 框架
       ;;racket            ; DSL 的 DSL
       ;;raku              ; 以前叫 perl6 的艺术家
       ;;rest              ; Emacs 作为 REST 客户端
       ;;rst               ; ReST 安息
       ;;(ruby +rails)     ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
       ;;(rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;;scala             ; java，但是好
       ;;(scheme +guile)   ; 一个完全共谋的 lisp 家族
       sh                ; 她在 C 异或上卖 {ba,z,fi}sh shell
       ;;sml
       ;;solidity          ; 你需要区块链吗？不。
       ;;swift             ; 谁要的表情符号变量？
       ;;terra             ; 地球和月亮为性能对齐
       ;;web               ; 管道
       ;;yaml              ; JSON，但是可读
       ;;zig               ; C，但是更简单

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;;calendar
       ;;emms
       ;;everywhere        ; *离开* Emacs！？你一定在开玩笑
       ;;irc               ; 大胡子们如何社交
       ;;(rss +org)        ; emacs 作为 RSS 阅读器

       :config
       ;;literate
       (default +bindings +smartparens))
