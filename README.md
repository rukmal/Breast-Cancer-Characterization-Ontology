# Ontology-enabled Breast Cancer Characterization Example Docker Implementation

This is an implementation of the [Knowledge Integration for Disease Characterization - A Breast Cancer Example](https://cancer-staging-ontology.github.io/) built using Docker.

To use the example, run the following:

- Clone the repository:

```shell
$ git clone https://github.com/rukmal/Breast-Cancer-Characterization-Ontology
$ cd Breast-Cancer-Characterization-Ontology
```

- Build the Docker container image

```shell
$ docker build . --tag bc-ontology
```

- Run the Docker container, with port passthrough

```shell
$ docker run -p 5000:5000 bc-ontology
```

## Usage Notes

- The username for the dummy user created is `test`, and the password is `test123`.

- The user information and other program runtime parameters can be changed by editing the [heals2vis_setup.sh](heals2vis_setup.sh) file.
