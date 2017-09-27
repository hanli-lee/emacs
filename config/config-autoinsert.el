(require 'autoinsert)
(auto-insert-mode t)
(setq auto-insert-query nil)
(setq auto-insert-alist nil)

(define-auto-insert '("\\.cpp\\'" . "C skeleton")
  '(
    "Short description:"
    "#include <"
    (file-name-sans-extension
     (file-name-nondirectory (buffer-file-name)))
    ".hpp>" \n \n
    > _ \n))

(define-auto-insert
  '("\\.\\([Hh]\\|hh\\|hpp\\)\\'" . "C / C++ header")
  '((s-upcase (s-snake-case (file-name-nondirectory buffer-file-name)))
    "#ifndef " str n "#define " str "\n\n" _ "\n\n#endif  // " str))

(define-auto-insert
  '(markdown-mode . "md skeleton")
  '("Short description: "
    "Title: " (s-titleized-words (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))) \n
    "Author: Li Han (韩立)" \n
    "\n" (s-titleized-words (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))) \n
    "====" \n
    > _ \n))

(define-auto-insert
  '(org-mode . "org skeleton")
  '("Short description: "
    "#+TITLE: " (s-titleized-words (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))) \n
    "#+AUTHOR: Li Han (韩立)" \n
    "#+EMAIL: hl09083253cy@126.com" \n
    "#+DATE: " (format-time-string (car org-time-stamp-formats) (current-time)) \n
    "* " (s-titleized-words (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))) \n
    > _ \n))

(define-auto-insert
  '(racket-mode . "racket skeleton")
  '("Short description: "
    "#lang racket"\n
    > - \n))

(define-auto-insert
  '(tintin-mode . "tintin skeleton")
  '("Short description: "
    "#class " (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) " open;" \n
    > _ \n
    "#class " (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) " close;" \n))

(define-auto-insert
  '(python-mode . "python skeleton")
  '("Short description: "
    "#!/usr/bin/env python3" \n
    "# -*- coding: utf-8 -*-  " \n \n \n
    "class Solution(object):" \n \n
    >"def "  (s-lower-camel-case (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))) "(self):" \n
    >"pass" \n
    > - \n \n
    < < "print(Solution()."(s-lower-camel-case (file-name-sans-extension (file-name-nondirectory (buffer-file-name))))"())" \n \n))

(define-auto-insert
  '(perl-mode . "perl skeleton")
  '("Short description: "
    "#!/usr/bin/env perl" \n
    > _ \n))

(define-auto-insert
  '(ruby-mode . "ruby skeleton")
  '("Short description: "
    "#!/usr/bin/env ruby" \n
    > _ \n))

(define-auto-insert
  '(js2-mode . "js skeleton")
  '("Short description: "
    "#!/usr/bin/env node" \n \n
    > _ \n))

(define-auto-insert
  '(web-mode . "html skeleton")
  '("Short description: "
    "<html lang=\"en\">
    <head>
        <meta charset=\"UTF-8\"/>
        <title>Test</title>

        <script src=\"https://code.jquery.com/jquery-3.1.1.min.js\"></script>
        <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\">
        <script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js\"></script>

        <script>
            $(\"document\").ready(function() {

            });
        </script>
        <style>
        </style>
    </head>
    <body>

    </body>
</html>"
    ))

(define-auto-insert
  '(rust-mode . "rust skeleton")
  '("Short description: "
    "use std::io;
use std::vec::Vec;
use std::cmp::max;
use std::collections::hash_set::HashSet as Set;
use std::collections::hash_map::HashMap as Map;

macro_rules! read_line(
    () => {{
        let mut line = String::new();
        io::stdin().read_line(&mut line);
        String::from(line.trim())
    }}
);

macro_rules! read_vector(
    () => {{
        let mut line = String::new();
        io::stdin().read_line(&mut line);
        let v: Vec<i32> = line.trim().split(\" \").map(|s| s.parse::<i32>().unwrap()).collect();
        v
    }}
);

macro_rules! read_int(
    () => {{
        let mut line = String::new();
        io::stdin().read_line(&mut line);
        let n:i32 = line.trim().parse().unwrap();
        n
    }}
);

fn main() {
" > _"
}
"
))
