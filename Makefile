build:
	docker build -t chat-ruby .

start: build
	docker run -p 9292:9292 -v ${PWD}:/build chat-ruby 

bundle-install:
	docker run -v ${PWD}/:/build --entrypoint bundle chat-ruby 'install'