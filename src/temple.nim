import std/[tables]
import temple/attributes

type
  TokenKind = enum
    Block, # A block is an HTML section.
    If, # signals an If condition
    End, # signals an End condition
    Item, # signals a template keyword
    Attribute, # signals an attribute
  
  Token = object
    case kind*: TokenKind
    of Block, Item, Attribute:
      inner*: string
    of If:
      condition*: string
      result*: bool
    else:
      discard

proc templateify*(
    input: string,
    data: Table[string, string],
    attributes: seq[TemplatingAttribute] = @[
      createAttribute("bold", bold),
      createAttribute("italic", italic),
      createAttribute("list_by_comma", list_by_comma),
      createAttribute("list_by_newline", list_by_newline),
      createAttribute("span_separated", span_separated)
    ]): string =

  var
    tokens: seq[Token]
    inItem = false
    tmp = ""

  proc addToTree(k: TokenKind, s: string = "", b: bool = false) = 
    ## A helper function for adding tokens to the tree easily.
    var token = Token(kind: k) 
    case k:
    of Block, Item, Attribute:
      token.inner = s
    of If:
      token.condition = s
      token.result = b
    else:
      discard
    tokens.add(token)

  proc toggle(b: var bool) =
    if b:b = false
    else: b = true

  # Tokenization process
  for ch in input:
    case ch:
    of '$':
      # Check if there is something in the tmp var already
      # If so, then create a token with the appropriate type
      if tmp != "":
        if inItem:
          case tmp:
          of "end":
            # Create an "End" token
            addToTree(End)
          else:
            # create an "Item" token with the tmp var
            # Since we are exiting a template keyword
            addToTree(Item, tmp)
        else:
          # create a normal "Block" token with the tmp var
          # Since we are creating a new template keyword
          addToTree(Block, tmp)
      # Either way, clear tmp at the end.
      tmp = ""

      # And flip the inItem switch on-and-off
      toggle(inItem)
    of '(':
      # It's probably an if statement
      # Clear tmp
      tmp = ""
    of ')':
      # Add whatever we hav captured as an if satement
      if tmp != "":
        # add a simple NOT check.
        var condition = data.hasKey(tmp)
        if tmp[0] == '!':
          toggle condition

        addToTree(If, tmp, data.hasKey(tmp))
      tmp = ""
    of '[':
      # Clear tmp variable and add whatever item has been parsed.
      if tmp != "":
        addToTree(Item, tmp)
      tmp = ""
    of ']':
      # Just add the attribute token.
      if tmp != "":
        addToTree(Attribute, tmp)
      tmp = ""
    else:
      tmp.add(ch)

  var
    i, currentIf = -1
    conditions: seq[bool]= @[]
  for token in tokens:
    inc i
    case token.kind:
    of Block:
      # Check if a condition block us first
      if currentIf >= 0:
        # If condition exists
        if conditions[currentIf] == false:
          continue # We gotta skip
        
      result.add(token.inner)
    of Item:
      # Check if a condition block us first
      if currentIf >= 0:
        # If condition exists
        if conditions[currentIf] == false:
          continue # We gotta skip

      if not data.hasKey(token.inner):
        continue # Check if item exists anyway
      
      var temp = data[token.inner]
      # Check first if this is the last token
      # Or if we can access any higher
      if i + 1 <= high(tokens):
        # If we can, then get the next token
        # and check its type
        # if its a "Attribute" token
        # then apply it
        let nextToken = tokens[i + 1]
        if nextToken.kind == Attribute:
          for attribute in attributes:
            if nextToken.inner == attribute.marker:
              temp = attribute.generator(temp)

      # Finally, add the temp variable to the result
      result.add(temp)
    of If:
      # Increase the if counter and add the condition to the list
      inc currentIf
      conditions.add(token.result)
    of End:
      # Decrease the currentIf counter
      # but make sure it doesn't go below -1
      if currentIf != -1:
        dec currentIf
        discard conditions.pop()
    of Attribute:
      # Attributes are already handled somewhere else, just skip.
      continue

  return result