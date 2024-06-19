# temple

A simple templating library

## How to

`$item$` to insert an item.

With support for conditionals:

```
$if(item)$
Text to be added if $item$ exists.
$end$
```

And attributes:

```
$item[attribute]$
```

Currently, the following attributes are available:
1. `bold`: Adds `<strong>` tags around the text, thus making it bold.
2. `bold`: Adds `<em>` tags around the text, thus making it italic.
3. `list_by_comma`: Creates a list with a comma as the separator
4. `list_by_newline`: Creates a list with newlines as the separator
5. `span_separated`: Wraps every character with `<span>` tags around it.


Attributes sadly cannot be stacked, and if conditions do not support else blocks.
These are things that I've got to add in the future, but meanwhile, you can do the following to work around the lack of else blocks

```
$if(item)$
First condition, this will display if item exists
$end$

$if(!item)$
Second condition, this will display if item doesn't exist.
And it acts like an else block.
$end$
```