# Asynchrony

Example **async** app using [Sinatra](https://github.com/sinatra/sinatra/) and a streaming api using [Grape](https://github.com/intridea/grape).

The complete app runs inside EventMachine and all Sinatra requests are handled asynchrously inside fibers. This allows the use of [EM-Synchrony](https://github.com/igrigorik/em-synchrony) in the Sinatra app.

An API endpoint using Grape serving a SSE ([Server-sent events](https://en.wikipedia.org/wiki/Server-sent_events)) stream is also exposed.

## Usage

```sh
bundle install
ruby app/boot.rb
```

It will start the server on port 9000.

endpoint | description
--- | ---
`/index.html` | mininal html app showing SSE messages from `api/v1/stream`
`/now` | regular request handled imediately
`/delayed` | request will asynchronously sleep for 10 seconds before returning result
`/nonblocking` | request will be deferred in an EventMachine thread and do a regular 10 seconds sleep before returning result
`/blocking` | request will freeze app with a regular sleep for 10 seconds
`/bang` | exception handling testing
`api/v1/stream` | SSE streaming messages at 1 sec interval

## Author

Colin Surprenant, [@colinsurprenant](http://twitter.com/colinsurprenant), [http://github.com/colinsurprenant](http://github.com/colinsurprenant), colin.surprenant@gmail.com

## License

Distributed under the Apache License, Version 2.0.
