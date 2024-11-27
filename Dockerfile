FROM ubuntu:18.04

# Install base libraries and Python 3.7
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    libpng16-16 \
    libtiff5 \
    libjpeg8 \
    build-essential \
    wget \
    git \
    python3.7 \
    python3.7-dev \
    python3-pip \
    libxerces-c-dev \
    fonts-freefont-ttf \
    fontconfig \
    nano \
    xvfb \
    # for ros scenario runner
    python-pexpect \
 && rm -rf /var/lib/apt/lists/*

# Set Python 3.7 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1

# Install Python dependencies
RUN pip3 install --upgrade pip setuptools==46.3.0 wheel==0.34.2 && \
    pip3 install simple_watchdog_timer==0.1.1 && \
    pip3 install py_trees==0.8.3 networkx==2.2 pygame==1.9.6 \
    six==1.14.0 numpy==1.18.4 psutil==5.7.0 shapely==1.7.0 xmlschema==1.1.3 ephem==3.7.6.0 tabulate==0.8.7 \
 && mkdir -p /app/scenario_runner 

# Install scenario_runner 
COPY . /app/scenario_runner

# Setup environment
ENV CARLA_HOST=""
ENV CARLA_RELEASE=""

# Set working directory
WORKDIR /app/scenario_runner

ENTRYPOINT ["/bin/bash"]