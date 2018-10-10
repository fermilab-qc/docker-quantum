# Docker-quantum

The docker-quantum repository provides several different containers with various
quantum computing simulation frameworks. They all contain jupyterlab and can be used
with a jupyterhub installation.

### holzman/base-notebook

Just jupyterlab. You probably don't want to use this.

### holzman/quantum-lite

Everything above, plus:

* Google's [cirq](https://github.com/quantumlib/cirq)
* IBM's [Qiskit Terra](https://qiskit.org/terra)
* [QuTiP](https://qutip.org)
* [OpenFermion](https://github.com/quantumlib/OpenFermion)


### holzman/quantum-full

Everything above, plus:

* Rigetti's [pyquil](https://github.com/rigetticomputing/pyquil)
* IBM's [Qiskit Aqua](https://qiskit.org/aqua)
* ETH Zurich's [ProjectQ](https://projectq.ch)
* Electronic structure packages:
    * [PySCF](https://github.com/sunqm/pyscf)
	* [Psi4](https://www.psicode.org)

### holzman/quantum-full-and-qsharp

Everything above, plus Microsoft's [Q#](https://docs.microsoft.com/en-us/quantum/). This image is twice as large as quantum-full.

## Quickstart (without Jupyterhub)

```
docker run -t 127.0.0.1:8888:8888 --name quantum -d holzman/quantum-full
docker logs quantum
```

Copy the URL from `docker logs` and paste into your web browser.

## Building locally

```
make
```





