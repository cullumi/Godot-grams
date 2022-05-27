extends Reference

class_name Trie

var root:TrieNode = newNode()

func newNode(val=null):
	return TrieNode.new(val)

func insert(key:Array, src=null):
	var pCrawl:TrieNode = root
	var length:int = key.size()
	for level in range(length):
		var index = key[level]
		if not pCrawl.children.has(index):
			pCrawl.children[index] = newNode(index)
		pCrawl = pCrawl.children[index]
	pCrawl.add_source(src)
	pCrawl.isEndOfWord = true

func search_result(pCrawl:TrieNode):
	if pCrawl.isEndOfWord:
		if not pCrawl.sources.empty():
			return pCrawl.sources
		else: return true
	else: return false

func search(key:Array):
	var pCrawl:TrieNode = root
	var length:int = key.size()
	for level in range(length):
		var index = key[level]
		if not pCrawl.children.has(index):
			return false
		pCrawl = pCrawl.children[index]
	return search_result(pCrawl)

func count(pCrawl:TrieNode=root) -> int:
	var num = pCrawl.count if pCrawl.isEndOfWord else 0
	for key in pCrawl.children.keys():
		num += count(pCrawl.children[key])
	return num

func traverse(pCrawl:TrieNode=root, result:Array=[], path:Array=[]) -> Array:
	if pCrawl.isEndOfWord:
		result.append(path)
	for ch in pCrawl.children.keys():
		var sub_path = path.duplicate()
		sub_path.append(ch)
		traverse(pCrawl.children[ch], result, sub_path)
	return result

func count_key(key:Array=[], pCrawl:TrieNode=root, depth:int=0) -> int:
	var num = 0
	if depth < key.size():
		var next = pCrawl.children[key[depth]]
		if next:
			var in_len = depth == key.size()-1
			if in_len and pCrawl.isEndOfWord:
				num += pCrawl.count
			num += count_key(key, next, depth+1)
	else: num += count(pCrawl)
	return num

func traverse_n(n:int, pCrawl:TrieNode=root, result:Array=[], path:Array=[], depth:int=0) -> Array:
	if depth == n and pCrawl.isEndOfWord:
		result.append(path)
	if depth < n:
		for ch in pCrawl.children.keys():
			var sub_path = path.duplicate()
			sub_path.append(ch)
			traverse_n(n, pCrawl.children[ch], result, sub_path, depth+1)
	return result

func traverse_n_key(n:int, key:Array, pCrawl:TrieNode=root, result:Array=[], path:Array=[], depth:int=0) -> Array:
	if depth == n and pCrawl.isEndOfWord:
		result.append(path)
	if depth < n:
		if depth < key.size():
			var next = pCrawl.children[key[depth]]
			if next:
				var sub_path = path.duplicate()
				sub_path.append(key[depth])
				traverse_n_key(n, key, next, result, sub_path, depth+1)
		else:
			for ch in pCrawl.children.keys():
				var sub_path = path.duplicate()
				sub_path.append(ch)
				traverse_n_key(n, key, pCrawl.children[ch], result, sub_path, depth+1)
	return result

func child_keys(key:Array) -> Array:
	var pCrawl:TrieNode = root
	var length:int = key.size()
	for level in range(length):
		var index = key[level]
		if not pCrawl.children.has(index):
			return []
		pCrawl = pCrawl.children[index]
	return pCrawl.children.keys()
