require! {broca, \dot-lens, Symbol: \es6-symbol}

stack = Symbol \stack

module.exports = :brio (compiler, templates, path, data)-->
	template = dot-lens path .get templates

	{body}:page = broca template
	if page.layout?
		s = data[][stack].concat path
		if page.layout in s
			throw new Error "Circular layout dependency #{(s ++ page.layout).join ' → '}"
		
		brio compiler, templates, page.layout, data import {page, body, (stack): s}
	else
		(compiler body) {page} import data
