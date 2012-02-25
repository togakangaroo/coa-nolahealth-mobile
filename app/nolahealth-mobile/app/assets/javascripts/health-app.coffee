$('[id$=-page]').live 'pageinit', ->
	console.log 'loaded page', this, arguments