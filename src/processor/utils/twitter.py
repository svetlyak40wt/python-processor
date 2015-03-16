import re


def remove_unnecessary_text(text):
    text = re.sub(r'Download the official Twitter app.*',
                  '', text)
    text = re.sub(r'Sent from my.*', '', text)
    text = re.sub(r'^\W+$', r'', text, flags=re.MULTILINE)
    text = re.sub(r'\n+', r'\n', text)
    return text


def swap_twitter_subject(subject, body):
    """If subject starts from 'Tweet from...'
    then we need to get first meaning line from the body."""

    if subject.startswith('Tweet from'):
        lines = body.split('\n')
        for idx, line in enumerate(lines):
            if re.match(r'.*, ?\d{2}:\d{2}]]', line) is not None:
                try:
                    subject = lines[idx + 1]
                except IndexError:
                    pass
                break
    return subject, body
