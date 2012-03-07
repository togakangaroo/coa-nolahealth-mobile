_.mixin
	zipHash: (collection1, collection2) ->
		_.reduce _.zip(collection1, collection2), ((acc, v) -> acc[v[0]] = v[1]; acc), {}

	sliceChunks: (collection, maxSize) -> 
		c = collection.slice 0
		r = []
		r.push(c.splice(0, maxSize)) while c.length
		r
