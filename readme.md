# Brio [![Build Status](https://travis-ci.org/quarterto/Brio.svg?branch=v0.1.1)](https://travis-ci.org/quarterto/Brio)

Templated layout builders.

```
npm install brio
```

![brio](http://irecommend.ru.q5.r-99.com/sites/default/files/product-images/9504/11534.jpg)

## Usage
(Pretending that Javascript has multiline strings)

```javascript
var brio = require('brio'), handlebars = require('handlebars');

var pages = brio(handlebars, {
	base: `<!doctype html>
	<html>
		<head>
			<title>{{page.title}}</title>
		</head>
		<body>
		{{{body}}}
		</body>
	</html>`,
	page: `---
	layout: 'base'
	---
	<h1>{{page.title}}</h1>
	<main>
	{{{body}}}
	</main>`,
	site: {
		home: `---
		title: 'Home',
		layout: 'page'
		---

		Welcome!`,
		post: `---
		title: 'Post'
		layout: 'page'
		---

		<h2>{{post.title}}</h2>
		<article>{{post.content}}</article>`
	}
});

pages('site.home', {}); /*⇒ <!doctype html>
	<html>
		<head>
			<title>Home</title>
		</head>
		<body>
		<h1>Home</h1>
			<main>
			Welcome!
			</main>
		</body>
	</html>
*/

pages('site.post', {post: {title: 'Hello world', content: 'Lorem ipsum dolor sit amet'}); /*⇒ <!doctype html>
	<html>
		<head>
			<title>Post</title>
		</head>
		<body>
		<h1>Post</h1>
			<main>
			<h2>Hello world</h2>
			<article>Lorem ipsum dolor sit amet</article>
			</main>
		</body>
	</html>
*/

```

## API
#### `brio :: (Template → Params → String) → Tree String Template → Path → Params → String`
Takes a templater, a tree of templates, a path to a template, some params and spits out a compiled string.
#### Templaters
Are any curried function taking a template and some parameters and returning a string. Handlebars fits nicely, as does `_.template`.

## Licence
MIT. &copy; 2014 Matt Brennan.
