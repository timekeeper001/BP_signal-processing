# BP_signal-processing
download_data.m: a script to download the signals that meet our requirements

BP_annotate.m: annotate PPG’s characteristic points (foot, systolic peak, dicrotic notch, and diastolic peak)
check_detector.m: plot out PPG and ECG signals every 5 minutes
detect_NaN.m: detect the percentage of NaN values in each signal (PPG, ECG and ABP)
detect_flat.m: detect the percentage of flat lines in each signal (PPG, ECG and ABP)
detect_rpeak.m: annotate r peak of ECG signals
filter_signal.m: a 4th-order Butterworth bandpass filter
generate_features.m: a function to generate all the required features
normalize_signal.m: min_max normalization

