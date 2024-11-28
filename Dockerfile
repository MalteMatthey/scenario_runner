FROM ubuntu:18.04

# Install base libraries and Python 2.7
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    libpng16-16 \
    libtiff5 \
    libjpeg8 \
    build-essential \
    wget \
    git \
    python2.7 \
    python2.7-dev \
    python-pip \
    libxerces-c-dev \
    fonts-freefont-ttf \
    fontconfig \
    nano \
    xvfb \
 && rm -rf /var/lib/apt/lists/*

# Set Python 2.7 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# Install Python dependencies
RUN pip install --upgrade pip==20.3.4 setuptools==44.1.1 wheel==0.34.2 && \
    pip install py_trees==0.5.1 networkx==1.11 pygame==1.9.6 \
    six==1.14.0 numpy==1.16.6 psutil==5.7.0 shapely==1.6.4 lxml==4.6.3 \
    ephem==3.7.6.0 tabulate==0.8.7 && \
    mkdir -p /app/scenario_runner

# Install scenario_runner 
COPY . /app/scenario_runner

# Setup environment
ENV CARLA_HOST=""
ENV CARLA_RELEASE=""

# Set working directory
WORKDIR /app/scenario_runner

ENTRYPOINT ["/bin/bash"]