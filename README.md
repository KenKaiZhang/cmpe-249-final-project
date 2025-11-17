# CMPE 249: IA Systems Final Project

## Overview

**The goal for this project is to decide whether or not there is a benefit in autonmous driving model performance when trained on synthetic data vs real-world data.**

The model in question for this project is the [Transfuser](https://github.com/autonomousvision/transfuser). Transfuser was trained on synthetic data generated via [Carla](https://carla.org/) and for this project, we will be retraining Transfuser with [nuPlan](https://www.nuplan.org/nuplan) and [Waymo Open Dataset](https://waymo.com/open/download/), very popular open source driving datasets current used in the industry today.

## Setup

To ensure as little variety as possible, our environment setup will be solely based on the README found in the [Transfuser](https://github.com/autonomousvision/transfuser) github folder. However, in our case, we have containerized the application for easier collaboration and environment isolation.

To build the environment on your machine, simply run ...
```
$ docker compose up -d
```

... and follow the instructions in transfuser/README.md.

