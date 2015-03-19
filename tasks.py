from invoke import run, task

@task
def upload():
    run('python setup.py register')
    run('python setup.py sdist upload')
    run('python setup.py bdist_wheel upload')

@task
def serve_docs():
    run('sphinx-build -b html docs dist/docs')
    run('cd dist/docs && python -mhttp.server --bind localhost')
