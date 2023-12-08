import os
import time

import requests

tags = {}

attributes = {
    "summary": {

    },
    "server stats": {
        'cpu load ave':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'cpu load std':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'cpu load max': {
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'cpu load min':  {
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,
        },
        'cpu utilization ave':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'cpu utilization std':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'cpu utilization max':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'cpu utilization min':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'memory ave':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'memory std':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'memory max':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'memory min':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'disk io ave':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'disk io std':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'disk io max':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
        'disk io min':{
            'umfs06': 3,
            'umfs09': 3,
            'umfs11': 3, 
            'umfs16': 3,
            'umfs19': 3,
            'umfs20': 3,
            'umfs21': 3,
            'umfs22': 3,
            'umfs23': 3,
            'umfs24': 3,
            'umfs25': 3,
            'umfs26': 3,
            'umfs27': 3,
            'umfs28': 3,  
        },
    },
    'paths': {
        "rbin": {
            'ports': {
                "et-8/0/0": {
                    "utilization In": 1,
                    "utilization Out": 1,
                    "bytes transferred In": 1,
                    "bytes transferred Out": 1,
                    "bytes per second In": 1,
                    "bytes per second Out": 1,
                },
                "et-8/2/0": {
                    "utilization": 1,
                    "bits": 1,
                    "bits per second": 1,
                },
            },
        },
        "chicaglt2": {
            'ports': {
                "et-0/3/0": {
                    "input": 1,
                    "output": 1,
                },
                "et-3/1/0": {
                    "input": 1,
                    "output": 1,
                },
                "et-1/3/0": {
                    "input": 1,
                    "output": 1,
                },
                "et-5/0/0": {
                    "input": 1,
                    "output": 1,
                },
                "et-0/1/0": {
                    "input": 1,
                    "output": 1,
                },
                "et-2/1/0": {
                    "input": 1,
                    "output": 1,
                },
            },
        },
    },
}

data = [
    {
        "tags": tags,
        "events": [
            {
                "timestamp": time.time() * 1000,
                "attributes": attributes,
            }
        ]
    }
]

resp = requests.post(
    f'{os.getenv("HUMIO_URL")}/api/v1/ingest/humio-structured',
    headers={
        'Authorization': f'Bearer {os.getenv("INGEST_TOKEN")}'
    },
    json=data,
)

resp.raise_for_status()
print(resp)