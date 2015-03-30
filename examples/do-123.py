#!/usr/bin/env python3

from processor import outputs, run_pipeline


def create_counter(name):
    return ({'counter': '{0} {1}'.format(name, i)}
            for i in range(10))

run_pipeline([create_counter('bob'),
              create_counter('joe')],
             [(lambda item: True, outputs.debug())])
