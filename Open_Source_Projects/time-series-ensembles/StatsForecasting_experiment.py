import sys
sys.path.append('..')

from src.util.ml_experiment import StatsForecastingExperiment

experiment = StatsForecastingExperiment(data_directory='data/stocks', base_dir = 'results',stock_symbols=None, target_transform='log_diff')
experiment.run()