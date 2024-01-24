# CDDEA: Community Detection Based On Differential Evolution Using Modularity Density

CDDEA is a community detection algorithm implemented in Octave. It leverages a differential evolution algorithm and modularity density to address the resolution limit problem of traditional modularity-based community detection methods.

## Paper Reference

For a detailed understanding of the CDDEA algorithm and its motivation, please refer to the paper:

**Community Detection Based on Differential Evolution Using Modularity Density**  
*Authors:* Caihong Liu and Qiang Liu  
*Published:* 30 August 2018  
*DOI:* [10.3390/info9090218](https://doi.org/10.3390/info9090218)

## Overview

Community detection is a critical task in network science, and CDDEA provides a novel approach by combining the strengths of differential evolution and modularity density to identify communities in a more effective and scalable manner.

## Features

- **Differential Evolution:** Utilizes the DE algorithm for global optimization in community detection.
- **Modularity Density:** Addresses the resolution limit problem by considering internal node distribution.
- **Adaptive Resolution:** CDDEA explores the network in different resolutions, eliminating the need for prior community structure knowledge.

## Algorithm Details

### 1. Introduction

CDDEA addresses the limitations of contemporary community detection methods, which often rely solely on modularity. Modularity-based methods face a resolution limit problem that hinders their ability to represent the real community structure of networks effectively.

### 2. Modularity Density

To overcome the resolution limit problem, CDDEA introduces modularity density as an optimized function. Modularity density considers the internal node distribution of a community, providing a more accurate representation of community structure.

### 3. Differential Evolution (DE)

CDDEA leverages the DE algorithm, a population-based stochastic search algorithm, for global optimization. DE's ability to find true global optimized values in multimodal search spaces, fast convergence, and utilization of genetic information from multiple individuals makes it a suitable choice for community detection.

### 4. Adaptive Resolution

CDDEA dynamically adjusts its exploration of the network in different resolutions. This adaptive approach eliminates the need for prior knowledge of community structure, making the algorithm robust and applicable to real-world problems with limited prior information.

