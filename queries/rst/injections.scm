;; extends

(directive
    name: (type) @_name
    body: (body
            (arguments) @language
            (content) @content))
 (#eq? @_name "code-block"))
