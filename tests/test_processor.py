import hy
from nose.tools import eq_

from processor import run_pipeline, extract_messages


def test_pipeline():
    def producer():
        return [{'message': 'blah',
                 'level': 'WARN'},
                {'message': 'minor',
                 'level': 'INFO'}]

    def trigger(msg):
        if msg.get('level') == 'WARN':
            return True

    warnings = []
    def action(msg):
        warnings.append(msg)

    rule = (trigger, action)
    run_pipeline(
        sources=[producer()],
        rules=[rule])

    eq_(1, len(warnings))


def test_messsages_extractor():
    source1 = [1, 2, 3, 4, 5]
    source2 = [6, 7, None, 8]
    desired_result = [1, 6, 2, 7, 3, 4, 8, 5]
    result = list(extract_messages([source1, source2]))
    eq_(desired_result, result)


def test_source_as_a_function():
    items = [1, 2, 3]
    result = []

    def source():
        if items:
            value = items.pop()
            print(value)
            return value
        print('None')
    run_pipeline(
        [source],
        [(lambda item: True, [result.append])])
    eq_([3, 2, 1], result)
