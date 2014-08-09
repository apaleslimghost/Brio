require! {broca, \dot-lens, Symbol: \es6-symbol}

stack = Symbol \stack

module.exports = :brio (compiler, templates, path, data)-->
	template = dot-lens path .get templates

	unless template?
		throw new ReferenceError "Path '#path' not found"
	else unless typeof template is \string
		throw new TypeError "Path '#path' resolves to invalid template"
	
	page = broca template
	page.body = body = (compiler page.body) {page} import data

	if page.layout?
		s = data[][stack].concat path
		if page.layout in s
			throw new Error "Circular layout dependency #{(s ++ page.layout).join ' → '}"
		
		brio compiler, templates, page.layout, data import {page, body, (stack): s}
	else
		body
