" Check Python files with flake8 and pylint.
let b:ale_linters = ['mypy', 'pyright', 'pylint']
" let b:ale_linters = ['mypy', 'pyright']
" Fix Python files with ...
let b:ale_fixers = ['autopep8', 'reorder-python-imports', 'trim_whitespace', 'autoimport']

"  let g:ale_completion_symbols = {
"  \ 'text': '',
"  \ 'method': '',
"  \ 'function': '',
"  \ 'constructor': '',
"  \ 'field': '',
"  \ 'variable': '',
"  \ 'class': '',
"  \ 'interface': '',
"  \ 'module': '',
"  \ 'property': '',
"  \ 'unit': 'unit',
"  \ 'value': 'val',
"  \ 'enum': '',
"  \ 'keyword': 'keyword',
"  \ 'snippet': '',
"  \ 'color': 'color',
"  \ 'file': '',
"  \ 'reference': 'ref',
"  \ 'folder': '',
"  \ 'enum member': '',
"  \ 'constant': '',
"  \ 'struct': '',
"  \ 'event': 'event',
"  \ 'operator': '',
"  \ 'type_parameter': 'type param',
"  \ '<default>': 'v'
"  \ }
"  
"   suggest.completionItemKindLabels": {
"        "variable": "\uf71b",
"        "constant": "\uf8ff",
"        "struct": "\ufb44",
"        "class": "\uf0e8",
"        "interface": "\ufa52",
"        "text": "\ue612",
"        "enum": "\uf435",
"        "enumMember": "\uf02b",
"        "color": "\ue22b",
"        "property": "\ufab6",
"        "field": "\uf93d",
"        "unit": "\uf475",
"        "file": "\uf471",
"        "value": "\uf8a3",
"        "event": "\ufacd",
"        "folder": "\uf115",
"        "keyword": "\uf893",
"        "snippet": "\uf64d",
"        "operator": "\uf915",
"        "reference": "\uf87a",
"        "typeParameter": "\uf278",
"        "default": "\uf29c"
"    }
