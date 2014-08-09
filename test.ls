require! {
	brio: './index.js'
	'expect.js'
	LiveScript
	vm
}

els = (template, data)-->
	LiveScript.compile 'return """' + template + '"""'
	|> vm.run-in-new-context _, data

brio-els = brio els

export 'Brio':
	'passes through text with no frontmatter': ->
		expect brio-els {a: "hello world"} \a {} .to.be "hello world"
	'external variables available at root': ->
		expect brio-els {a: '#a world'} \a {a: "hello"} .to.be "hello world"
	'frontmatter variables available in page object': ->
		expect brio-els {
			a: '''
			---
			a: 'hello'
			---
			#{page.a} world
			'''
		} \a {} .to.be "hello world"
	'nested objects available as dotted access': ->
		expect brio-els {a: b: "hello world"} \a.b {} .to.be "hello world"
	'layouts':
		'replace content': ->
			expect brio-els {
				a: '''
				---
				layout: 'b'
				---

				goodbye, chuck
				'''
				b: "hello world"
			} \a {} .to.be "hello world"

		'have inner available as body': ->
			expect brio-els {
				a: '''
				---
				layout: 'b'
				---

				world
				'''
				b: 'hello #{body}'
			} \a {} .to.be "hello world"

		'can be nested': ->
			expect brio-els {
				a: '''
				---
				layout: 'b'
				---

				world
				'''
				b: '''
				---
				layout: 'c'
				---

				hello #{body}
				'''
				c: 'well #{body}'
			} \a {} .to.be "well hello world"

		'barf on circular dependencies': ->
			expect brio-els {
				a: '''
				---
				layout: 'b'
				---

				hello
				'''
				b: '''
				---
				layout: 'a'
				---

				world
				'''
			} .with-args \a {} .to.throw-exception /Circular layout dependency a → b → a/

