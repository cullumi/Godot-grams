extends Reference

class_name TrieNode

var children = {}
var isEndOfWord = false
var value = null
var traversalOrder:int = -1
var sources:Array = []
var count:int = 0

func _init(val=null):
	value = val

func add_source(src=null):
	if src != null: sources.append(src)
	count += 1
