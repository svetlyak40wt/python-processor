import hy
from nose.tools import eq_

from processor import run_pipeline


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

    run_pipeline(producer(),
                 [trigger, action])

    eq_(1, len(warnings))
