;;; $DOOMDIR/early-init.el -*- lexical-binding: t; -*-  
;; 早期初始化文件 - 在 Doom 启动早期加载

;; =============================================
;; 国内镜像源配置 (China Mirror Configuration)
;; =============================================
;; 此文件在 Doom Emacs 启动早期加载，用于配置国内镜像源

;; 配置 ELPA 国内镜像 (清华大学 TUNA)
(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("org"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

;; =============================================
;; Straight 国内镜像配置
;; =============================================
;; Doom 使用 straight.el 作为包管理器，需要从 GitHub 克隆仓库
;; 以下配置使用国内镜像或加速访问

;; 方法1: 使用 Emacs China 的镜像 (推荐)
(setq straight-recipes-gnu-elpa-use-mirror t)
(setq straight-recipes-gnu-elpa-mirror-url
      "https://git.savannah.gnu.org/git/emacs/elpa.git")

;; 方法2: 配置 GitHub 镜像 (通过替换 URL)
;; 注意：以下配置会在 Doom 加载前设置环境变量
(defun +straight-mirror-github-to-ghproxy (url)
  "将 GitHub URL 转换为 ghproxy 镜像地址"
  (if (string-match "https://github.com/\\(.*\\)" url)
      (concat "https://ghproxy.com/https://github.com/" (match-string 1 url))
    url))

;; 方法3: 使用 FastGit 镜像
(defun +straight-mirror-github-to-fastgit (url)
  "将 GitHub URL 转换为 fastgit 镜像地址"
  (if (string-match "https://github.com/\\(.*\\)" url)
      (concat "https://hub.fastgit.xyz/" (match-string 1 url))
    url))

;; 方法4: 使用 KGit 镜像 (国内较稳定)
(defun +straight-mirror-github-to-kgit (url)
  "将 GitHub URL 转换为 kgit 镜像地址"
  (if (string-match "https://github.com/\\(.*\\)" url)
      (concat "https://kgithub.com/" (match-string 1 url))
    url))

;; 启用 GitHub 镜像 (取消下面一行的注释来选择镜像源)
;; (setq straight-vc-git-default-clone-url #'+straight-mirror-github-to-ghproxy)
;; (setq straight-vc-git-default-clone-url #'+straight-mirror-github-to-fastgit)
(setq straight-vc-git-default-clone-url #'+straight-mirror-github-to-kgit)

;; =============================================
;; Git 配置建议 (需要在 shell 中执行)
;; =============================================
;; 为了提高 Git 克隆速度，建议在 ~/.gitconfig 中添加：
;;
;; [url "https://ghproxy.com/https://github.com/"]
;;     insteadOf = https://github.com/
;;
;; 或者使用 SSH 代理：
;; [core]
;;     sshCommand = ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:1080 %h %p"
;;
;; =============================================

;; 禁用 SSL 验证 (仅在无法解决 SSL 问题时临时使用，不推荐)
;; (setq straight-vc-git-default-clone-args '("--depth" "1" "-c" "http.sslVerify=false"))

;; 设置 Git 克隆深度为 1，加速克隆
(setq straight-vc-git-default-clone-args '("--depth" "1"))

;;; early-init.el 结束
