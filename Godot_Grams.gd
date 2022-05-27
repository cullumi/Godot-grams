extends TileMap

export (int, 0, 500) var source_width
export (int, 0, 1000) var width
export (int, 0, 100) var height
export (int, 0, 10) var rows
export (int, 1, 500) var n
export (bool) var random

var source:Array = []
var feats:Array = []
var grams:Trie = null
var probs:Dictionary = {}

const START:int = -1
const END:int = -2


### The Overal Process

func _unhandled_input(event):
	if event.is_action_pressed("reload"):
		clear()
		populate(random)

func _ready():
	source = parse_source()
	feats = parse_feats()
	grams = parse_grams()
	probs = generate_probs()
	populate(random)


### Setting and Getting Cells

func apply_feat(x:int, feat:Dictionary):
	var elem = feat.val
	for y in range(0, height):
		set_cell(x, y, elem[y])

func parse_source():
	var source = []
	for row in range(0, rows):
		source.append([])
		for x in range(0, source_width):
			source[row].append([])
			for y in range(0, height):
				source[row][x].append(get_cell(x, y + row*height))
				set_cell(x, y, -1)
	return source



### Vocabulary Parsing

func parse_feats() -> Array:
	# Generate Feats Trie
	var trie = Trie.new()
	for row in range(rows):
		var src_len = source[row].size()
		for idx in range(src_len):
			var elem:Array = source[row][idx]
			trie.insert(elem, {"row":row, "idx":idx})
	return generate_feats(trie)

func generate_feats(trie:Trie) -> Array:
	# Generate Feats Dictionary
	var set = trie.traverse()
	var all_feats = []
	for row in range(rows):
		var feats = []
		all_feats.append(feats)
		var src_len = source[row].size()
		feats.resize(src_len+2)
		feats[0] = START
		feats[src_len+1] = END
	for idx in range(set.size()):
		var elem = set[idx]
		var srcs = trie.search(elem)
		var feat = {"val":elem, "srcs":srcs}
		for src in srcs:
			all_feats[src.row][src.idx+1] = feat
	return all_feats


### N-Gram Creation and Probability Assignment

func parse_grams() -> Trie:
	# Generate Grams Trie
	var grams:Trie = Trie.new()
	for row in range(rows):
		var src_len:int = feats[row].size()
		for i in range(src_len):
			for j in range(i, src_len+1):
				var src = {"row":row, "idx":i}
				grams.insert(feats[row].slice(i, j), src)
	return grams

func generate_probs() -> Dictionary:
	var n_grams:Array = grams.traverse_n(n)
	var probs:Dictionary = {}
	for n_gram in n_grams:
		var n_count:float = grams.count_key(n_gram)
		var m_count:float = grams.count_key(n_gram.slice(0, n_gram.size()-2))
		probs[n_gram] = (n_count/m_count)
	return probs


### N-Gram Level Generation

func select_n_gram(key:Array):
	var keys:Array = grams.traverse_n_key(n, key)
	var max_key:Array
	var max_prob:float = -INF
	for key in keys:
		if probs[key] > max_prob:
			max_key = key
			max_prob = probs[key]
	return max_key

func select_rand_n_gram(key:Array):
	var keys:Array = grams.traverse_n_key(n, key)
	var wrand:WRandom = WRandom.new()
	for key in keys:
		wrand.add_weight(key, probs[key])
	wrand.init_probabilities()
	return wrand.pick()

func n_gram_start(n_gram):
	if n_gram == null: return false
	var front = n_gram.front()
	return front is int and front == START

func n_gram_end(n_gram):
	if n_gram == null: return false
	var back = n_gram.back()
	return back is int and back == END

func populate(rand:bool=false):
	var key = [START]
	for xi in range(0, width):
		var n_gram
		if rand:
			while ((xi < width-n and n_gram_end(n_gram)) or n_gram == null):
				n_gram = select_rand_n_gram(key)
		else:
			n_gram = select_n_gram(key)
		key = n_gram.slice(1, n_gram.size()-1)
		if n_gram_start(n_gram):
			for xj in range(1, n):
				var x = xi + xj
				apply_feat(x, n_gram[xj])
		elif n_gram_end(n_gram):
			break
		else:
			apply_feat(xi+(n-1), n_gram[(n-1)])

