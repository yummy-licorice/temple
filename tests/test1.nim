import temple, std/tables

echo templateify(
  """
$if(exists_and_full)$
<p>$exists_and_full$</p>
$end$

$if(!exists_and_full)$
<p>I shouldn't be running! A</p>
$end$
  """,
  {"exists_and_full": "Hi! I exist and I am full!"}.toTable
)
echo templateify(
  """
$if(exists_and_not_full)$
<p>I shouldn't be running! B</p>
$end$

$if(!exists_and_not_full)$
<p>Helo! I should be running!</p>
$end$
  """,
  {"exists_and_not_full": ""}.toTable
)

echo templateify(
  """
$if(doesnt_exist)$
<p>I shouldn't be running! C</p>
$end$

$if(!doesnt_exist)$
<p>Helo! I should be running! C</p>
$end$
  """,
  initTable[string,string]()
)


echo templateify(
  "<h1>$name$</h1>",
  {"name":"John"}.toTable
)

echo templateify(
  """
$if(enabled)$
$if(result)$
<h1>$result$</h1>
$end$
$end$

$if(!enabled)$
<h2>Help</h2>
$end$
  """,
  {
    "result":"John",
    "enabled":"true",
  }.toTable
)