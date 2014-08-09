require! {
	brio: './index.js'
	'expect.js'
	handlebars
}

brio-handlebars = brio handlebars

export 'Brio':
	'passes through text with no frontmatter': ->
		expect brio-handlebars {a: "hello world"} \a {} .to.be "hello world"
	'external variables available at root': ->
		expect brio-handlebars {a: "{{a}} world"} \a {a: "hello"} .to.be "hello world"
	'frontmatter variables available in page object': ->
		expect brio-handlebars {
			a: """
			---
			a: 'hello'
			---
			{{page.a}} world
			"""
		} \a {} .to.be "hello world"
	'nested objects available as dotted access': ->
		expect brio-handlebars {a: b: "hello world"} \a.b {} .to.be "hello world"
	'layouts':
		'replace content': ->
			expect brio-handlebars {
				a: """
				---
				layout: 'b'
				---

				goodbye, chuck
				"""
				b: "hello world"
			} \a {} .to.be "hello world"

		'have inner available as page.body': ->
			expect brio-handlebars {
				a: """
				---
				layout: 'b'
				---

				world
				"""
				b: "hello {{page.body}}"
			} \a {} .to.be "hello world"

		'can be nested': ->
			expect brio-handlebars {
				a: """
				---
				layout: 'b'
				---

				world
				"""
				b: """
				---
				layout: 'c'
				---

				hello {{page.body}}
				"""
				c: "well {{page.body}}"
			} \a {} .to.be "well hello world"

		'barf on circular dependencies': ->
			expect brio-handlebars {
				a: """
				---
				layout: 'b'
				---

				hello
				"""
				b: """
				---
				layout: 'a'
				---

				world
				"""
			} .with-args \a {} .to.throw-exception /Circular layout dependency a → b → a/

