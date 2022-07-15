TAG := vinay_terraform_hello_world 

build:
	docker-compose build

run:
	docker-compose up

login-to-ecr:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 695208304199.dkr.ecr.eu-west-2.amazonaws.com

build-and-push:
	ecr=$$(cd ..; terraform output -raw ecr-uri); \
	ref="0.1"; \
	tag="$(TAG):latest"; \
	remote_tag=$${ecr}:$${ref}; \
	docker-compose build; \
	docker tag ${{tag}} ${{remote_tag}} ; \
	make login-to-ecr; \
	docker push $${remote_tag}

