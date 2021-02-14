build:
	docker build -t chat-ruby .

start: build
	-docker rm chat-ruby
	docker run --name chat-ruby -p 9292:9292 -v ${PWD}:/build chat-ruby 

bundle-install:
	docker run -v ${PWD}/:/build --entrypoint bundle chat-ruby 'install'