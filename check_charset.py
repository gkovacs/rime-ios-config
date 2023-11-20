import opencc
converter = opencc.OpenCC('t2s.json')

all_chars = set()
for filename in ['jyut6ping3.chars.dict.yaml', 'terra_pinyin.dict.yaml', 'cangjie5_tradsimp.dict.yaml']:
  for line in open(filename, 'rt'):
    if '\t' not in line:
      continue
    line_parts = line.split('\t')
    chars = line_parts[0]
    for c in chars:
      all_chars.add(c)

def is_gbk(c):
  try:
    c.encode('gbk')
    return True
  except:
    return False

do_not_convert = []
for c in all_chars:
  if not is_gbk(c):
    continue
  c_simp = converter.convert(c)
  if c == c_simp:
    continue
  if not is_gbk(c_simp):
    do_not_convert.append([c, c_simp])

stchars = open('opencc/TSCharacters_custom.txt', 'wt')
for c, c_simp in do_not_convert:
  print(f'{c}\t{c}', file=stchars)
  print(f'{c_simp}\t{c}', file=stchars)
