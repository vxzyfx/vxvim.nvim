;; extends
; css(`...`), css`...`,  etc.
(call_expression
  function: (identifier) @injection.language
  arguments: [
    (arguments
      (template_string) @injection.content)
    (template_string) @injection.content
  ]
  (#eq? @injection.language "css")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children))
