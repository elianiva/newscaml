let hello world =
  let open Dream_html in
  let open HTML in
  html [lang "en"] [
    head [] [
      title [] "Dream-html" ];
    body [] [
      h1 [] [txt "Hello "; txt world]; ]]

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream_html.respond (hello "world"));
  ]
