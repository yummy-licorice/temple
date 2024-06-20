import temple, std/tables

let txt = """
<h1>$item$</h1>

A
$if(item)$
<p>Item: hello</p>
$end$

B
$if(!item)$
<p>Item: Hello 2</p>
$end$

C
$if(item_b)$
<p>Item: helloee</p>
$end$

D
$if(!item_b)$
<p>Item: Hello 2eee</p>
$end$
"""
let resolt = templateify(
  txt,
  {
   "item": "Hello!",
   "item_b": ""
  }.toTable
)
echo "---"
stdout.write resolt


echo templateify(
  "<h1>$name$</h1>",
  {"name":"John"}.toTable
)