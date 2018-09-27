.PHONY: base-notebook cirq-notebook quantum-nb quantum-and-qsharp-nb

all: base-notebook cirq-notebook quantum-nb quantum-and-qsharp-nb

base-notebook: base-notebook/Dockerfile
	docker build -t docker.io/holzman/base-notebook base-notebook

cirq-notebook: base-notebook/Dockerfile cirq-notebook/Dockerfile
	docker build -t docker.io/holzman/cirq-notebook cirq-notebook

quantum-nb: base-notebook/Dockerfile cirq-notebook/Dockerfile quantum-nb/Dockerfile
	docker build -t docker.io/holzman/quantum-nb quantum-nb

quantum-and-qsharp-nb: base-notebook/Dockerfile cirq-notebook/Dockerfile quantum-nb/Dockerfile quantum-and-qsharp-nb/Dockerfile
	docker build -t docker.io/holzman/quantum-and-qsharp-nb quantum-and-qsharp-nb


