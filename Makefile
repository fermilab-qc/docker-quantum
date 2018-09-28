.PHONY: base-notebook quantum-lite quantum-full quantum-full-and-qsharp

all: base-notebook quantum-lite quantum-full quantum-full-and-qsharp

base-notebook: base-notebook/Dockerfile
	docker build -t docker.io/holzman/base-notebook base-notebook

quantum-lite: base-notebook/Dockerfile quantum-lite/Dockerfile
	docker build -t docker.io/holzman/quantum-lite quantum-lite

quantum-full: base-notebook/Dockerfile quantum-lite/Dockerfile quantum-full/Dockerfile
	docker build -t docker.io/holzman/quantum-full quantum-full

quantum-full-and-qsharp: base-notebook/Dockerfile quantum-lite/Dockerfile quantum-full/Dockerfile quantum-full-and-qsharp/Dockerfile
	docker build -t docker.io/holzman/quantum-full-and-qsharp quantum-full-and-qsharp


