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

	'barfs if template not found': ->
		expect brio-els {a: "hello world"} .with-args \b {} .to.throw-exception /Path 'b' not found/
	'barfs if nested template not found': ->
		expect brio-els {a: "hello world"} .with-args \a.b {} .to.throw-exception /Path 'a.b' not found/
	'barfs if template not found in empty thing': ->
		expect brio-els {} .with-args \a {} .to.throw-exception /Path 'a' not found/
	'barfs if nested template not found in empty thing': ->
		expect brio-els {} .with-args \a.b {} .to.throw-exception /Path 'a.b' not found/
	'barfs if template not a string': ->
		expect brio-els {a: 5} .with-args \a {} .to.throw-exception /Path 'a' resolves to invalid template/

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

		'layouts can be dotted': ->
			expect brio-els {
				a: '''
				---
				layout: 'b.c'
				---

				hello
				'''
				b: c: '#{body} world'
			} \a {} .to.be "hello world"

		'layouts work at top level from dotted templates': ->
			expect brio-els {
				a: b: '''
				---
				layout: 'c'
				---

				hello
				'''
				c: '#{body} world'
			} \a.b {} .to.be "hello world"

	'inner page variables':
		'are available to layouts': ->
			expect brio-els {
				a: '''
				---
				layout: 'b'
				title: 'hi'
				---

				hello
				'''
				b: '#{page.title}: #{body} world'
			} \a {} .to.be "hi: hello world"

		'are available to nested layouts': ->
			expect brio-els {
				a: '''
				---
				layout: 'b'
				title: 'hi'
				---

				world
				'''
				b: '''
				---
				layout: 'c'
				---

				hello #{body}
				'''
				c: '#{page.title}: well #{body}'
			} \a {} .to.be "hi: well hello world"

		'are available to intermediate nested layouts': ->
			expect brio-els {
				a: '''
				---
				layout: 'b'
				title: 'hi'
				---

				world
				'''
				b: '''
				---
				layout: 'c'
				---

				#{page.title}: hello #{body}
				'''
				c: 'well #{body}'
			} \a {} .to.be "well hi: hello world"

		'are available from intermediate nested layouts': ->
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
				title: 'hi'
				---

				hello #{body}
				'''
				c: '#{page.title}: well #{body}'
			} \a {} .to.be "hi: well hello world"
