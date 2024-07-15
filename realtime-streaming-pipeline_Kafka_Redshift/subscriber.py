#!/usr/bin/env python3

from kafka import KafkaConsumer
from kafka import KafkaProducer
import json
import os
import logging
import polars as pl
import tomli

# Configuration
with open("parameters.toml", mode="rb") as params:
    config = tomli.load(params)

logging.basicConfig(level=config["general"]["logging_level"])
bootstrap_servers = config["general"]["bootstrap_servers"]
topics = config["general"]["topics"]
delta_path = config["subscriber"]["delta_path"]

def create_consumer(topics, bootstrap_servers):
    return KafkaConsumer(
        *topics,
        bootstrap_servers=bootstrap_servers,
        auto_offset_reset='earliest',
        enable_auto_commit=True,
        group_id='my-group',
        key_deserializer=lambda k: json.loads(k.decode('utf-8')),
        value_deserializer=lambda v: json.loads(v.decode('utf-8'))
    )

def create_producer(bootstrap_servers):
    return KafkaProducer(
        bootstrap_servers=bootstrap_servers,
        key_serializer=lambda k: json.dumps(k).encode('utf-8'),
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )

if __name__ == "__main__":
    consumer = create_consumer(topics, bootstrap_servers)
    producer =  create_producer(bootstrap_servers)

    for message in consumer:
        pass