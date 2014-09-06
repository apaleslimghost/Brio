require! {broca, flat.flatten, Symbol: \es6-symbol, deepmerge, create-errors: \bunch-of-errors}

stack = Symbol \stack
errors = create-errors {
	PathNotFoundError: ReferenceError
	InvalidTemplateError: TypeError
	\CircularDependencyError
}

module.exports = :brio (compiler, templates, path, data)-->
	template = flatten templates .[path]

	unless template?
		throw new errors.PathNotFoundError "Path '#path' not found"
	else unless typeof template is \string
		throw new errors.InvalidTemplateError "Path '#path' resolves to invalid template"
	
	page = broca template
	page.body = body = (compiler page.body) {page} `deepmerge` data

	if page.layout?
		s = data[][stack].concat path
		if page.layout in s
			throw new errors.CircularDependencyError "Circular layout dependency #{(s ++ page.layout).join ' → '}"
		
		brio compiler, templates, page.layout, data `deepmerge` {page, body, (stack): s}
	else
		body

module.exports import {errors}
