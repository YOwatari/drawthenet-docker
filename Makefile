DOCKER_IMAGE := yowatari/drawthenet

run: build
	docker run --rm -p 8000:80 $(DOCKER_IMAGE)

build: Dockerfile
	docker build -t $(DOCKER_IMAGE) -f $< .

