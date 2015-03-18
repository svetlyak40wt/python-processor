from invoke import run, task

@task
def upload():
    run('python setup.py register')
#    run('python setup.py sdist upload')
    run('python setup.py bdist_wheel upload')
