(lang dune 3.16)

(name newscaml)

(generate_opam_files true)

(source
 (github elianiva/newscaml))

(authors "elianiva")

(maintainers "elianiva")

(license LICENSE)

(documentation https://github.com/elianiva/newscaml)

(package
 (name newscaml)
 (synopsis "News aggregator")
 (description "News aggregator")
 (depends
   (dream (>= 1.0.0~alpha7))
   (dream-html (>= 3.6.2))
   (utop (>= 2.14.0))
   (dune (>= 3.16))
   (ocaml (>= 5.2.0)))
 (tags
  (topics news aggregator scraping)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
