_.mixin
	zipHash: (collection1, collection2) ->
		_.reduce _.zip(collection1, collection2), ((v, acc) -> acc[v[0]] = v[1]; acc), {}