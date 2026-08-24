# nRF52832 Medical RF System

Collaborative academic project focused on modeling an RF communication system with error detection and correction for a medical application using the Nordic Semiconductor nRF52832 SoC as the target platform.

The project combines biomedical signal preprocessing, statistical analysis, error-control coding, RF-channel simulation, GFSK/FSK modulation and demodulation, BER evaluation, and PCB design.

## Project Overview

The system was developed as an end-to-end communication-chain study for transmitting physiological information through a noisy wireless channel. The repository includes signal-processing notebooks, MATLAB simulations, channel models, coding/decoding experiments, PCB design files, datasets, technical reports, and final project documentation.

Main areas covered:

- Biomedical signal preprocessing and BPM-data analysis
- Statistical characterization and outlier detection
- Error-control coding and decoding
- Hamming (15,11) error correction
- AWGN channel modeling
- GFSK/FSK modulation and demodulation
- BER analysis under different SNR conditions
- PCB design associated with the nRF52832 platform
- Technical documentation and final project report

## Communication Pipeline

The project studies the following general flow:

1. **Signal preprocessing** — physiological data are prepared and statistically characterized before transmission.
2. **Error-control coding** — information is encoded to provide resilience against transmission errors.
3. **RF-channel modeling** — an AWGN model is used to reproduce channel degradation under different noise conditions.
4. **Modulation and demodulation** — FSK/GFSK processing is evaluated using MATLAB-based simulations.
5. **Error correction and validation** — received information is decoded and compared with the original data using BER-related metrics.
6. **Hardware design** — EAGLE files document the PCB-level design associated with the nRF52832-based system.

## Signal Preprocessing

The Jupyter workflow includes statistical preprocessing of BPM data, including descriptive statistics, normality analysis with the Anderson–Darling test, outlier evaluation, filtering, and execution-time measurements.

The repository also contains generated figures and processed datasets used to compare preprocessing methods and characterize the physiological data before the communication stages.

## Error-Control Coding

The communication chain includes Hamming-code experiments for error detection and correction. One of the implemented decoding stages uses **Hamming (15,11)** and evaluates both the raw channel errors and the remaining information-bit errors after decoding.

An example recorded experiment at 1 dB reports:

- 1395 encoded bits evaluated
- 26 raw code-bit errors
- 20 corrected Hamming (15,11) errors
- 1023 information bits compared
- 9 post-decoding information errors
- Post-decoding information BER: approximately `8.80e-03`

These values correspond to one specific simulation condition and are included as an example of the decoder validation workflow.

## RF Channel and Modulation

The repository contains:

- An AWGN channel implementation
- FSK/GFSK modulation and demodulation scripts
- Received-signal datasets at multiple SNR values
- BER-vs-SNR results and figures
- Encoded and decoded bit sequences used for validation

MATLAB and Jupyter were used together to analyze different stages of the communication chain.

## PCB Design

The `EAGLE/` directory contains board, project, job, and component-library files associated with the hardware design. Nordic Semiconductor libraries are included for the nRF-related components used in the project.

## Repository Structure

```text
nRF52832-Medical-RF-System/
├── Documentacion/   # Progress reports, final presentation and paper
├── EAGLE/           # PCB and schematic design files
├── Jupyter/         # Data processing, statistics and communication-system analysis
├── Matlab/          # Modulation, demodulation and RF simulation files
├── Proyectos_Proyecto_TCE_2025.pdf
└── README.md
```

## My Contributions — Kendall Madrigal

This was a collaborative project. My contributions documented in the Git history include:

- Development of statistical-analysis utilities and environment configuration for the preprocessing workflow
- Implementation and refinement of the physiological-data preprocessing block
- Anderson–Darling normality analysis and supporting descriptive statistics
- Outlier-analysis logic and preprocessing corrections
- Development of a functional Hamming (15,11) decoding block
- Decoder corrections and validation using BER-related results
- Integration work within the RF-system repository
- Final repository organization and corrections to the final paper

The original Git history and contributor attribution are preserved in this portfolio copy.

## Academic Context

This repository is an independent portfolio copy of a **collaborative academic project** originally developed in `LexieVaneska/Grupo2_TCE`.

The original commit history has been preserved so that individual contributions remain traceable to their respective authors.

## Technologies and Tools

- Python
- Jupyter Notebook
- NumPy / Pandas / SciPy / Matplotlib
- MATLAB
- C
- EAGLE
- Digital communications and RF-channel simulation
- Error-control coding
- Nordic Semiconductor nRF52832
