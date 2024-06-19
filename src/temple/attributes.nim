proc italic(s: string): string  =
  return "<em>" & s & "</em>"

proc bold(s: string): string  =
  return "<strong>" & s & "</strong>"

proc list(s: string, separator: char): string =
  var
    backslash = false
    tmp = ""
  for ch in s:
    if backslash:
      backslash = false
      continue

    if ch == '\\':
      backslash = true
      continue
    
    if ch == separator:
      result.add("<li>" & tmp & "</li>\n")
      tmp = ""
      continue

    tmp.add(ch)
  
  if tmp != "":
    result.add("<li>" & tmp & "</li>\n")
  
  return result

proc span_separated(s: string): string =
  for ch in s:
    if ch == ' ':
      result.add(" ")
    else:
      result.add("<span>" & ch & "</span>")
  return result

proc list_by_comma(s: string): string =
  return list(s, ',')

proc list_by_newline(s: string): string =
  return list(s, '\n')

type
  TemplatingAttribute* = object of RootObj
    marker*: string
    generator*: proc (s: string): string

func createAttribute*(marker: string, generator: proc (s: string): string): TemplatingAttribute =
  result.marker = marker
  result.generator = generator
  return result

let defaultAttributes* = @[
  createAttribute("bold", bold),
  createAttribute("italic", italic),
  createAttribute("list_by_comma", list_by_comma),
  createAttribute("list_by_newline", list_by_newline),
  createAttribute("span_separated", span_separated)
]