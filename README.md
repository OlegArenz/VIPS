# Variational Inference by Policy Search
Variational Inference by Policy Search (VIPS) is a method for learning Gaussian Mixture Model approximations of intractable probability density functions for the purpose of inference (e.g. sampling).<br>
VIPS does not require knowledge about gradients or normalizing constants. The optimization leverages insights from Policy Search (hence the name) by using information-geometric trust region to improve the approximation in a controlled manner for better stability and exploration.<br>
More details about the method can be found in the [paper](http://www.ausy.tu-darmstadt.de/uploads/Team/OlegArenz/VIPS.pdf).

## Installation
This implementation can be used with Python 3. However, most of the algorithm is implemented in C++ and interfaced via [SWIG](http://www.swig.org).<br>
It should actually be easy to use this as a pure C++ library, however the learning loop is only implemented in python for now (see [python/sampler/VIPS/VIPS.py](python/sampler/VIPS/VIPS.py)).<br>
Installation consists of two parts. You first need to install some libraries needed by VIPS (OpenBlas, Armadillo and NLOPT). Afterwards the C++ part of VIPS can be compiled.

### Compiling the C++ Libraries
The following instructions will install nlopt and armadillo+OpenBLAS locally into ~/libs.
When installing into a different directory, the [CMakeList.txt](CMakeList.txt) needs to be modified.<br>
Instructions are based on https://gist.github.com/BERENZ/ff274ebbf00ee111c708.

#### Install OpenBlas
In some temporary directory run:

```bash
$ git clone git://github.com/xianyi/OpenBLAS.git
$ cd OpenBLAS/
$ git checkout develop
$ mkdir ~/libs
$ USE_OPENMP=1 NO_SHARED=1 COMMON_OPT=" -O2 -march=native" make
$ make PREFIX=~/libs/OpenBlas NO_SHARED=1 install
```

#### Install armadillo
Download armadillo into ~/libs

```bash
$ cd ~/libs
~/libs$ wget http://sourceforge.net/projects/arma/files/armadillo-8.300.3.tar.xz
```
You can also check for a newer version at http://arma.sourceforge.net/download.html

Unpack and configure it (Don't make it, we just need the headers)

```bash
~/libs$ tar xJvf armadillo-8.300.3.tar.xz
~/libs$ mv armadillo-8.300.3 armadillo
~/libs$ rm armadillo-8.300.3.tar.xz
$ cd armadillo
$ ./configure
```

#### Install NLOPT
```bash
$ wget http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz
$ tar xzvf nlopt-2.4.2.tar.gz
$ cd nlopt-2.4.2/
$ ./configure --enable-shared --prefix=$HOME/libs/nlopt && make && make install
add the following lines to your ~/.bashrc:
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/libs/nlopt/lib
export LD_LIBRARY_PATH
```

### Compiling VIPS
Make sure that swig is installed

```
$ sudo apt install swig
```
Change into ./c++ and compile the project:

```
$ mkdir build
$ cd build
$ cmake ..
$ make install -j4
```

### Getting Started
Scripts for the experiments of the [paper](http://www.ausy.tu-darmstadt.de/uploads/Team/OlegArenz/VIPS.pdf) can be found in [python/experiments/VIPS/](python/experiments/VIPS/).
Make sure that [python](python) is in your path when running the scripts or run them as modules, e.g.
```bash
/VIPS/python/$ python3 -m experiments.VIPS.breast_cancer
```
Check [python/experiments/VIPS/rosenbrock.py](python/experiments/VIPS/rosenbrock.py) for an easy example of how to use VIPS for approximating a given density function.

## Citation
If you use this package in your own work please cite our paper:

Arenz, O.; Zhong, M.; Neumann, G. Efficient Gradient-Free Variational Inference using Policy Search. _Proceedings of the 35th International Conference on Machine Learning_. 2018.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

