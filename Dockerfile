FROM ros:noetic

# Set environment
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-catkin-tools \
    python3-vcstool \
    git \
    nano \
    wget \
    sudo \
    software-properties-common \
    lsb-release \
    gnupg \
    ros-noetic-ros-numpy \
    ros-noetic-pcl-ros \
    ros-noetic-rviz \
    ros-noetic-tf \
    ros-noetic-tf-conversions \
    ros-noetic-eigen-conversions \
    ros-noetic-navigation \
    ros-noetic-gmapping \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libeigen3-dev \
    libprotobuf-dev \
    protobuf-compiler \
    ros-noetic-cv-bridge \
    ros-noetic-vision-opencv \
    && rm -rf /var/lib/apt/lists/*


SHELL ["/bin/bash", "-c"]

# Add GTSAM PPA and install GTSAM 4.x
RUN add-apt-repository -y ppa:borglab/gtsam-release-4.0 && \
    apt-get update && apt-get install -y \
    libgtsam-dev libgtsam-unstable-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up catkin workspace
RUN mkdir -p /root/catkin_ws/src

# Copy liorf_localization package into workspace
COPY ./liorf_localization /root/catkin_ws/src/liorf_localization

# Build the workspace
WORKDIR /root/catkin_ws
RUN bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Set up environment sourcing on container start
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

WORKDIR /root/catkin_ws
CMD ["bash"]