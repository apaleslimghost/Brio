require! [broca, \dot-lens]

module.exports = (compiler, templates, path, data)-->
	template = dot-lens path .get templates

	{body}:page = broca template

	(compiler body) data import {page}
