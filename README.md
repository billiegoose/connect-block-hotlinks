# connect-block-hotlinks

I wrote this middleware to keep people from embedding my site's images into their own sites.
It compares the HTTP headers `Host` and `Referer` to make sure they are from the same 2nd-level domain.
For example, if Host is `img.example.com` then referer can be `http://example.com/` or `http://blog.example.com/`
but not `http://another.com/`.

This will not stop a determined attacker! For that you should use CORS and authentication mechanisms. But it will
prevent people stealing your bandwidth by using a URL to your image in the 'src' of an <image> tag on another site.

## API

It follows a classic Connect/Express middleware pattern:

```
var express = require('express');
var blockHotlinks = require('connect-block-hotlinks');

var app = express();
app.use "/img/*", blockHotlinks
```

Depending on the request, the middleware will either:

- do nothing, and call next() so the route can be handled by the next route handler.
- return a 403 Forbidden "Missing 'Host' HTTP Header"
- return a 403 Forbidden "Missing 'Referer' HTTP Header"
- return a 200 OK hotlinking-disallowed.png
