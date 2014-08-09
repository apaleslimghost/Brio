require! [broca, \dot-lens]

module.exports = :brio (compiler, templates, path, data)-->
	template = dot-lens path .get templates

	{body}:page = broca template
	if page.layout?
		brio compiler, templates, that, data import {page}
	else
		(compiler body) {page} import data
