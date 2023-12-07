"""
    ExperimentClass for ML Models to run on datasets
"""
import os

from datetime import datetime

import pandas as pd
import numpy as np

# sktime imports
from sktime.forecasting.model_selection import SlidingWindowSplitter

# sklearn imports
from sklearn.pipeline import make_pipeline
from sklearn.linear_model import Ridge, Lasso
from sklearn.neighbors import KNeighborsRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score, mean_absolute_percentage_error

# category encoders
from category_encoders import OneHotEncoder, TargetEncoder

'''
StatsForecasting
'''
import os
import time
import re 
import sys
sys.path.append('..')
import warnings 
warnings.filterwarnings('ignore')
import pandas as pd 
import numpy as np
import plotly.express as px
import plotly.offline as pyo
from pandas_datareader.data import DataReader
import yfinance as yf 
from pandas_datareader import data as pdr
from datetime import datetime 
import category_encoders as ce
from statsmodels.tsa.stattools import adfuller
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.tools.sm_exceptions import ConvergenceWarning
import matplotlib.pyplot as plt
import logging
from multiprocessing import cpu_count
from joblib import Parallel, delayed
pd.options.plotting.backend = "plotly"
pyo.init_notebook_mode()
yf.pdr_override()



class _BaseExperimentClass():
    """Base Class for a Forecasting Experiment, to be inherited for ML, Stats, and DL Experiments"""

    def __init__(self, data_file: str, exp_name: str, models: list, train_size: int):
        self.data_file = data_file
        self.exp_name = exp_name
        self.models = models
        self.train_size = train_size

    def _load_data(self):
        """Load in dataset"""
        self.data = pd.read_csv(f'data/{self.data_file}', parse_dates = ['date'])

        # validate data
        self._validate_data()

        # set index
        self.data.set_index(['series', 'date'], inplace = True)

    def _validate_data(self):
        """Basic error checking for data inputs

        Assumes input data has the following columns:
            series: str, name of the entity being forecasted
            date:   str, date of the observation
            value:  float or int, value of the observation
        """

        # check that data has the right columns
        assert 'series' in self.data.columns, 'Data must have a series column'
        assert 'date' in self.data.columns, 'Data must have a date column'
        assert 'value' in self.data.columns, 'Data must have a value column'

        # check that data has no missing values
        assert self.data.isna().sum().sum() == 0, 'Data must have no missing values'

        # check that data has no duplicate rows
        assert self.data.duplicated().sum() == 0, 'Data must have no duplicate rows'

        # check that data has no duplicate (series, date) pairs
        assert self.data.groupby(['series', 'date']).size().max() == 1, 'Data must have no duplicate (series, date) pairs'

        # check that data has has the correct types
        assert self.data['series'].dtype == 'object', 'Series column must be of type object'
        assert self.data['date'].dtype == 'datetime64[ns]', 'Date column must be of type datetime64[ns]'
        assert self.data['value'].dtype in ['float64', 'int64'], 'Value column must be of type float64 or int64'

    def _create_X_y(self):
        """Needs to be modified for each experiment class"""
        pass

    def _create_train_and_test(self):
        """Create training and test sets for X & y"""

        # create training and test sets
        grouping = self.data.groupby(level = 0)
        train, test = grouping.apply(lambda x: x.iloc[:self.train_size]), grouping.apply(lambda x: x.iloc[self.train_size:])

        train = train.dropna()
        test  = test.dropna()

        self.X_train, self.X_test = train.drop(columns = ['target', 'value', 'naive_forecast']), test.drop(columns = ['target', 'value', 'naive_forecast']) 
        self.y_train, self.y_test = train['target'], test['target']

    def _calc_naive_forecast(self):
        """Creates a Naive Baseline for the Dataset"""
        self.data['naive_forecast'] = self.data.groupby(level = 0)['value'].shift(1).values

    def _calculate_error_metrics(self, preds_df: pd.DataFrame) -> pd.DataFrame:
        """Calculate error metrics for each model"""

        # drop rows with missing values in the predictions
        preds_df = preds_df.dropna()

        pred_cols = [col for col in preds_df if 'pred' in col]

        # store the results
        results = []
        for col in pred_cols:
            results.append({
                'model': col,
                'mae': mean_absolute_error(preds_df['y_true'], preds_df[col]),
                'rmse': mean_squared_error(preds_df['y_true'], preds_df[col], squared = False),
                'mape': mean_absolute_percentage_error(preds_df['y_true'], preds_df[col]),
                'r2': r2_score(preds_df['y_true'], preds_df[col])
            })

        # calculate the naive forecast error metrics
        naive_dates = self.data.index.get_level_values(1)
        mask = naive_dates.isin(preds_df['date'])
        naive_preds = self.data.loc[mask, 'naive_forecast'].values
        naive_y_true = self.data.loc[mask, 'value'].values

        results.append({
            'model': 'naive_forecast',
            'mae': mean_absolute_error(naive_y_true, naive_preds),
            'rmse': mean_squared_error(naive_y_true, naive_preds, squared = False),
            'mape': mean_absolute_percentage_error(naive_y_true, naive_preds),
            'r2': r2_score(naive_y_true, naive_preds)
        })

        # return results as a dataframe
        return pd.DataFrame(results)
    
    def _create_results_directory(self):
        """Create directory to save results for this dataset
        """
        dataset_name = self.data_file.split('.')[0]
        self.path_to_create = os.path.abspath(f'results/{dataset_name}_{self.exp_name}')
        os.makedirs(self.path_to_create, exist_ok = True)

    def run(self):
        """To be modified for each experiment class"""
        pass

    def _fit_data(self):
        """To be modified for each experiment class"""
        pass

class MLForecastingExperiment(_BaseExperimentClass):

    def __init__(self, 
                 data_file: str, 
                 exp_name: str,
                 models: list, 
                 target_transform: str, 
                 lags: list = [1, 2, 3, 7],
                 calibration_windows: list = [7, 14],
                 encode_entity: bool = True,
                 train_size: int = 120,

                 # list of date parts to encode for date features
                 date_parts_to_encode: list = ['month'],
                 window_transforms: dict = None):

        # inherit from ForecastingExperiment
        super().__init__(data_file, exp_name, models, train_size)

        # arguments specific to MLForecastingExperiment
        self.target_transform = target_transform
        self.lags = lags
        self.calibration_windows = calibration_windows
        self.window_transforms = window_transforms
        self.encode_entity = encode_entity
        self.date_parts_to_encode = date_parts_to_encode

    def _transform_target(self):
        """Apply target transformation to data"""

        # difference target
        if self.target_transform == 'diff':
            self.data['target'] = self.data.groupby(level = 0)['value'].diff()

        # log transform target
        elif self.target_transform == 'log':
            self.data['target'] = self.data.groupby(level = 0)['value'].apply(np.log1p)

        # log difference target
        elif self.target_transform == 'log_diff':
            self.data['target'] = self.data.groupby(level = 0)['value'].apply(np.log1p).diff().values

        # no transformation
        elif self.target_transform == None:
            pass

    def _create_window_transforms(self):
        """Create window transforms based off of time based features in target"""

        for transform in self.window_transforms.keys():
            if hasattr(self.data['value'].rolling(0), transform):
                for window in self.window_transforms[transform]:
                    self.data[f'{transform}_{window}'] = getattr(self.data.groupby(level = 0)['target'].rolling(window), transform)().values
                    self.data[f'{transform}_{window}'] = self.data.groupby(level = 0)[f'{transform}_{window}'].shift().values

    def _create_X(self):
        """Create X based off of time based features in target"""

        # create X based off of lags
        for lag in self.lags:
            self.data[f'lag_{lag}'] = self.data.groupby(level = 0)['target'].shift(lag).values

        # create X based off of window transforms
        if self.window_transforms is not None:
            self._create_window_transforms()

        if self.encode_entity:
            self.data['entity'] = self.data.index.get_level_values(0)

        if self.date_parts_to_encode is not None:
            self._add_date_features()

        # drop rows with missing values
        self.data.dropna(inplace = True)

    def _create_X_y(self):
        """Create X and y for whole dataset"""

        # create X
        self._create_X()

        # create train and test
        self._create_train_and_test()

    def _fit_data(self, encoder, model):
        """Fit data using sliding window one step ahead forecasting"""

        # store the results for each training window
        final_window_results = []

        # loop through each calibration window
        for window in self.calibration_windows:
            window_results = []
            print(f"Fitting model w/ a window size of: {window}")
            splitter = SlidingWindowSplitter(fh = [1], 
                                window_length = window, # this is the experimental variable we want to manipulate
                                step_length = 1)
            
            # use sliding window one step ahead forecasting for each
            # series simultaneously
            for train_idx, val_idx in splitter.split(self.X_train.index):

                # transform the training data
                X_train_temp = encoder.fit_transform(self.X_train.iloc[train_idx], self.y_train.iloc[train_idx])

                # fit the model
                model.fit(X_train_temp, self.y_train.iloc[train_idx])

                # transform the test data
                X_val_temp = encoder.transform(self.X_train.iloc[val_idx])

                # predict on the test data
                y_pred = model.predict(X_val_temp)

                # store the results
                window_results.append(pd.DataFrame({
                                                    'date': X_val_temp.index.get_level_values(2),
                                                    'series': X_val_temp.index.get_level_values(1),
                                                    'y_pred': y_pred, 
                                                    'y_true': self.y_train.iloc[val_idx].values
                                                    }))
                
            # concatenate the results
            window_results_df = pd.concat(window_results)
            window_results_df['window'] = window
            final_window_results.append(window_results_df)
                
        # format the results from each window
        final_exp_results = pd.concat(final_window_results, axis = 0)

        # format the results so they are easier to read
        pivoted_results = final_exp_results.pivot_table(
            index = ['series', 'date'], 
            columns = 'window')
        
        # flatten the column names
        pivoted_results.columns = [f'{col[0]}_{col[1]}' 
                                   for col in pivoted_results.columns]
        true_cols       = [col for col in pivoted_results if 'true' in col]
        pivoted_results = pivoted_results.drop(true_cols[1:], axis = 1)
        pivoted_results.rename({
            true_cols[0]: 'y_true'
            }, axis = 1, inplace = True)
        
        # reset the index
        pivoted_results.reset_index(inplace = True)

        return pivoted_results
    
    def run(self):
        """Function to run experiment with all available models"""

        # load data
        self._load_data()

        # create directory to save the results
        self._create_results_directory()

        # create naive forecast
        self._calc_naive_forecast()

        # transform target
        self._transform_target()

        # create X and y
        self._create_X_y()

        # create data encoder
        self._build_data_encoder()

        experiment_results = []

        # fit data
        for model in self.models:
            print(f"Fitting model for {model}")
            results = self._fit_data(self.data_encoder, model)
            metrics = self._calculate_error_metrics(results)

            # save results
            results.to_csv(f'{self.path_to_create}/{model}_preds.csv', index = False)
            metrics.to_csv(f'{self.path_to_create}/{model}_metrics.csv', 
                            index = False)
    


    def _add_date_features(self):
        """Create date features based off of date_parts_to_encode"""

        # create date features, sugglested list of date parts to encode: 
        # ['year', 'month', 'day', 'dayofweek', 'dayofyear', 'weekofyear']
        # only use ones that are appropriate for your data
        # for more information on other date parts see: https://pandas.pydata.org/docs/user_guide/timeseries.html#time-date-components
        for date_part in self.date_parts_to_encode:
            if hasattr(self.data.index.get_level_values(1), date_part):
                self.data[date_part] = getattr(self.data.index.get_level_values(1), date_part)

    def _build_data_encoder(self):
        """Create data transformer based off of presence of different columns
        
        Standard data encoding scheme is as follows:
            date parts are one-hot encoded
            entity is target encoded
        """
        # create data encoder
        self.data_encoder = make_pipeline(
            OneHotEncoder(cols = self.date_parts_to_encode, use_cat_names = True))
        
        if self.encode_entity:
            self.data_encoder.steps.append(('target_encoder', TargetEncoder(cols = ['entity'])))

# class StatsForecastingExperiment(_BaseExperimentClass):
#   """Empty Experimental Class for Jem to fill in"""
#    pass


class StatsForecastingExperiment:
    def __init__(self, data_directory='data/stocks', base_dir='results', stock_symbols=None, target_transform=None):
        self.data_directory = data_directory
        self.base_dir = base_dir
        self.target_transform = target_transform
        self.stock_data = {}
        self.panel_data = None
        self.panel_data_processed = None
        self.results_dfs = []
        self.results_df = None
        self.final_arima_predictions_df = None
        self.metrics_df = None
        self.stock_symbols = stock_symbols if stock_symbols else ["AAPL", "MSFT", "GOOGL", "TSLA", "AMZN", "PLTR", "AMD", "NVDA", "META", "BAC"]

    def load_data(self):
        final = []

        for symbol in self.stock_symbols:
            file_path = os.path.join(self.data_directory, f'{symbol}.csv')

            #Read csv files and load to df 
            stock_df = pd.read_csv(file_path, index_col='Date', parse_dates=True)

            #Save DataFrame to a stock data dictionary
            self.stock_data[symbol] = stock_df

            #Extract the Close value and create panel data
            vals = stock_df['Close'].tolist()
            tmp_df = pd.DataFrame()
            tmp_df['Series'] = [symbol] * len(vals)
            tmp_df['Date'] = stock_df.index
            tmp_df['Values'] = vals
            final.append(tmp_df)

        self.panel_data = pd.concat(final)
        self.panel_data.set_index(['Series', 'Date'], inplace=True)

        return self.panel_data

    def _transform_target(self):
        """Apply target transformation to data"""

        # difference target
        if self.target_transform == 'diff':
            differences = self.panel_data.groupby(['Series'])['Values'].diff().reset_index().dropna()
            self.panel_data = differences.set_index(['Series', 'Date'])

        # log transform target
        elif self.target_transform == 'log':
            log_returns =np.log1p(self.panel_data).groupby(['Series'])['Values'].diff().reset_index().dropna()
            self.panel_data = log_returns.set_index(['Series', 'Date'])

        # log difference target
        elif self.target_transform == 'log_diff':
            final = []
            for symbol in self.stock_symbols:
                vals = self.stock_data[symbol]['Close'].tolist()
                log_diffs = np.log(np.array(vals[1:]) / np.array(vals[:-1]))
                differences_log_diffs = log_diffs[1:] - log_diffs[:-1]
                
                tmp_df = pd.DataFrame()
                tmp_df['Series'] = [symbol] * len(differences_log_diffs)
                tmp_df['Date'] = self.stock_data[symbol].index[2:]
                tmp_df['Values'] = differences_log_diffs
                final.append(tmp_df)

            panel_data_log_diffs = pd.concat(final)
            self.panel_data = panel_data_log_diffs.set_index(['Series', 'Date'])

        # no transformation
        elif self.target_transform is None:
            pass
    
        return self.panel_data

    def additional_preprocessing(self):
        """Additional preprocessing after transformation."""

        dfs_list = []

        # Get each stock symbol
        symbols = self.panel_data.index.get_level_values('Series').unique()
        for symbol in symbols:
            # Subset dataframe per stock
            subset = self.panel_data.loc[symbol]

            # Convert index to datetime to set frequency and use ffill
            subset.index = pd.to_datetime(subset.index)
            subset = subset.asfreq('B').fillna(method='ffill')

            # Convert index back to a period and append series column
            subset.index = subset.index.to_period('D')
            subset['Series'] = symbol
            subset.set_index('Series', append=True, inplace=True)
            subset = subset.swaplevel('Series', 'Date')

            dfs_list.append(subset)

        # Concatenate the processed dataframes
        self.panel_data_processed = pd.concat(dfs_list)

        return self.panel_data_processed

    def _process_stock(self, stock, window_sizes, data):
        #Ignore the warnings from ARIMA model
        #But are these really harmless though?
        warnings.filterwarnings("ignore", category=ConvergenceWarning)
        warnings.filterwarnings("ignore", category=UserWarning)
        results = []

        #Log information about stock and data 
        logging.info(f"Processing stock: {stock} with data points: {len(data)}")

        for window_size in window_sizes:
            arima_predictions = []
            for i in range(len(data) - window_size):
                train_data = data.iloc[i:i + window_size]

                model = ARIMA(train_data, order=(1, 1, 0))
                results_arima = model.fit()
                y_pred = results_arima.forecast(steps=1)
                arima_predictions.append(y_pred.iloc[0])

            results.append((stock, window_size, arima_predictions))

        return results
    
    def predict_using_arima(self):
        window_sizes = [3, 15, 30]
        stock_names = self.stock_symbols  # Using the stock_symbols attribute

        #Group arguments for process function in a tuple
        args = [(stock, window_sizes, self.panel_data_processed.loc[stock, 'Values'].dropna()) for stock in stock_names]

        #Get the number of cores, keep one free for other tasks just in case 
        num_cores = max(cpu_count() - 1, 1)

        #Process the stocks in parallel
        results_nested = Parallel(n_jobs=num_cores, batch_size=6)(delayed(self._process_stock)(stock, window_sizes, data) for stock, window_sizes, data in args)

        #Flatten the list of results, to get the desired output I want 
        #Parallel processing of stocks gives me a nested list 
        self.results_dfs = [item for sublist in results_nested for item in sublist]  

        # Log the results
        logging.info(f"Completed processing with {len(self.results_dfs)} result sets.")

        return self.results_dfs

    def process_results(self):
        results_df = pd.DataFrame(columns=['Stock', 'Window Size', 'Date', 'Original Price', 'ARIMA Prediction'])

        for stock, window_size, arima_predictions in self.results_dfs:
            data = self.panel_data_processed.loc[stock]['Values'].dropna()
            window_size_predictions = arima_predictions
            date_index = data.index[-len(window_size_predictions):]
            original_prices = data.values[-len(window_size_predictions):]
            
            stock_results = pd.DataFrame({
                'Stock': [stock] * len(window_size_predictions),
                'Window Size': [window_size] * len(window_size_predictions),
                'Date': date_index,
                'Original Price': original_prices,
                'ARIMA Prediction': window_size_predictions
            })

            results_df = pd.concat([results_df, stock_results], ignore_index=True)

        self.results_df = results_df  
        return self.results_df  

    def transform_predictions(self):
        # Transform the ARIMA predictions back to stock prices
        arima_predictions_list = []

        for stock in self.stock_symbols:  # Use the instance variable stock_symbols
            stock_df = self.stock_data[stock]
            stock_df.index = pd.to_datetime(stock_df.index)

            for window_size in [3, 15, 30]:
                stock_window_df = self.results_df[(self.results_df['Stock'] == stock) & (self.results_df['Window Size'] == window_size)]
                
                for index, row in stock_window_df.iterrows():
                    date = row['Date'].to_timestamp()
                    arima_prediction = row['ARIMA Prediction']

                    if date in stock_df.index:
                        original_price = stock_df.loc[date]['Close']
                        arima_prediction_transformed = original_price * np.exp(arima_prediction)
                        
                        arima_predictions_list.append({
                            'Stock': stock,
                            'Date': date,
                            'Original Price': original_price,
                            'Window Size': window_size, 
                            'ARIMA Prediction Transformed': arima_prediction_transformed
                        })

        final_arima_predictions_df = pd.DataFrame(arima_predictions_list)

        # Use pivot to modify the dataframe to have a column for each window size
        final_arima_predictions_df = final_arima_predictions_df.pivot_table(index=['Stock', 'Date', 'Original Price'], columns='Window Size', values='ARIMA Prediction Transformed', aggfunc='first').reset_index()

        new_columns = []

        for col in final_arima_predictions_df.columns:
            if isinstance(col, int):  
                new_name = f'ARIMA Pred Window {col}'
                new_columns.append(new_name)       
            else:
                new_columns.append(col)

        final_arima_predictions_df.columns = new_columns

        self.final_arima_predictions_df = final_arima_predictions_df  # Store the final results in an attribute
        return self.final_arima_predictions_df

    def calculate_performance_metrics(self):
        metrics = []

        def inner_calculate_metrics(y_true, y_pred):
            # Remove NaN values
            mask = ~np.isnan(y_pred)
            y_true = y_true[mask]
            y_pred = y_pred[mask]

            mape = mean_absolute_percentage_error(y_true, y_pred)
            rmse = np.sqrt(mean_squared_error(y_true, y_pred))
            mae = mean_absolute_error(y_true, y_pred)
            
            return {
                "MAPE": mape,
                "RMSE": rmse,
                "MAE": mae,
            }

        stocks = self.final_arima_predictions_df['Stock'].unique()

        for stock in stocks:
            stock_df = self.final_arima_predictions_df[self.final_arima_predictions_df['Stock'] == stock]
            y_true = stock_df['Original Price']

            for window_size in [3, 15, 30]:
                y_pred = stock_df[f"ARIMA Pred Window {window_size}"]
                if y_pred.isna().all():  # Skip if all values are NaN
                    continue

                metrics_values = inner_calculate_metrics(y_true, y_pred)
                metrics.append({
                    'Stock': stock,
                    'Window Size': window_size,
                    'MAPE': metrics_values['MAPE'],
                    'RMSE': metrics_values['RMSE'],
                    'MAE': metrics_values['MAE']
                })

        self.metrics_df = pd.DataFrame(metrics)
        return self.metrics_df

    
    def save_results(self, base_dir='results'):
        # Create a directory for saving results
        now = datetime.now()
        date_time_str = now.strftime('%Y%m%d_%H%M%S')
        new_dir = os.path.join(self.base_dir, f"arima_experimental_{date_time_str}")
        if not os.path.exists(new_dir):
            os.makedirs(new_dir)

        # Save results to the directory
        self.final_arima_predictions_df.to_csv(os.path.join(new_dir, 'final_arima_predictions.txt'), sep='\t', index=False)
        self.metrics_df.to_csv(os.path.join(new_dir, 'metrics.txt'), sep='\t', index=False)

        window_sizes = [3, 15, 30]

        # Plot and save figures for each stock
        for stock in self.final_arima_predictions_df['Stock'].unique():
            filtered_df = self.final_arima_predictions_df[self.final_arima_predictions_df['Stock'] == stock]

            dates = filtered_df['Date']
            y_true = filtered_df['Original Price']

            plt.figure(figsize=(12, 6))
            plt.plot(dates, y_true, label='True Values', linewidth=2)

            for window_size in window_sizes:
                y_pred = filtered_df[f'ARIMA Pred Window {window_size}']
                plt.plot(dates, y_pred, label=f'{window_size} Window Predictions', linestyle='--', linewidth=2)

            plt.xlabel('Date')
            plt.ylabel('Price')
            plt.title(f'{stock} - True and Predicted Values Comparison')
            plt.legend()
            plt.grid(True)
            plt.savefig(os.path.join(new_dir, f'{stock}_plot.png'))
            plt.close()

    def run(self):
        """Execute the ARIMA forecasting experiment from start to finish."""
        print("Starting ARIMA forecasting experiment...")
        
        print("Loading data...")
        self.load_data()
        
        print("Transforming target...")
        self._transform_target()

        print("Preprocessing data...")
        self.additional_preprocessing()

        print("Predicting using ARIMA...")
        self.predict_using_arima()

        print("Processing ARIMA results...")
        self.process_results()

        print("Transforming predictions...")
        self.transform_predictions()

        print("Calculating performance metrics...")
        self.calculate_performance_metrics()

        print("Saving results and plots...")
        self.save_results()

        print("ARIMA forecasting experiment completed successfully!")
       
