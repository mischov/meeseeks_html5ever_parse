Example showing difference in `Html5ever.parse_sync` and `Html5ever.parse_async` when used with `Meeseeks.Document.new`.

```
$ git clone https://github.com/mischov/meeseeks_html5ever_parse.git
$ cd meeseeks_html5ever_parse
$ mix deps.get
$ MIX_ENV=prod mix compile
$ MIX_ENV=prod mix run -e MeeseeksHtml5everParse.run
Running tests...
Parsed with Html5ever async in 17250.7 us
Parsed with Html5ever sync in 18877.3 us

Created Meeseeks Document from tuples in 6883.2 us

Parsed with Meeseeks async in 66956.9 us
Parsed with Meeseeks sync in 33076.9 us
```
