## Wave-docker-template
Template repository to create a dockerized H2O Wave application from scratch.

If you want to create a Wave application, select this repo as a templated when creating your app's repository.

### Run on virtual environment with poetry:

**Pre-requisites**

- pip
- poetry

```
# Installing dependencies
$ poetry config virtualenvs.create true
$ poetry install
$ poetry shell

$ wave run --no-reload --no-autostart app.app
```

You can see the app through localhost http://127.0.0.1:10101

To stop running Press Ctrl + C

To stop virtual env 
```
$ exit
```

### Run on virtual environment with Conda

**Pre-requisites**

- mamba or conda

```
$ mamba env create --file conda/local.yaml
```
You can use conda instead of mamba `$ conda env create --file conda/env.yml`

To activate virtual env and run the app

```
$ conda activate waveapp

$ wave run app/app.py
```

You can see the app through localhost http://127.0.0.1:10101

### Run with docker-compose :

**Pre-requisites**

* Docker installed and running
* Install make docker-compose with:
```bash
$ mamba env create --file conda/containers.yaml
```

Then:
```bash
$ make containers-build

# When dependencies change and you need to force a rebuild
$ make containers-start

# When finished
$ make containers-down
```

You can see the app through localhost http://127.0.0.1:10101
