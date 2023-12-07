from statsmodels.tsa.arima.model import ARIMA


def arima_forecast_statsmodels(stock, window_size, data):
    arima_predictions = []
    for i in range(len(data) - window_size):
        train_data = data.iloc[i:i + window_size]
        model = ARIMA(train_data, order=(1, 1, 0))
        results = model.fit()
        y_pred = results.forecast(steps=1)
        arima_predictions.append(y_pred.iloc[0])
    return (stock, window_size, arima_predictions)


'''
import statsmodels.api as sm


def arima_forecast_statsmodels(stock, window_size, data):
    arima_predictions = []
    for i in range(len(data) - window_size):
        train_data = data.iloc[i:i + window_size].values
        model = sm.tsa.ARIMA(train_data, order=(1, 1, 0))
        results = model.fit(disp=0)
        y_pred = results.forecast(steps=1)[0]
        arima_predictions.append(y_pred[0])
    return (stock, window_size, arima_predictions)
'''


'''
from sktime.forecasting.arima import ARIMA

def arima_forecast(stock, window_size, data):
    arima_predictions = []
    for i in range(len(data) - window_size):
        train_data = data.iloc[i:i + window_size]
        model = ARIMA(order=(1, 1, 0))
        model.fit(train_data)
        y_pred = model.predict(fh=np.array([1]))
        arima_predictions.append(y_pred[0])
    return (stock, window_size, arima_predictions)
'''
