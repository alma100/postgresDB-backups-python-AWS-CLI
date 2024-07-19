from setuptools import find_packages, setup

with open('README.md', 'r') as f:
    long_desc = f.read()

setup(
    name='pgbackup',
    version='0.1.0',
    author='Aba',
    description='Test project vagy mi :)',
    long_description=long_desc,
    long_description_content_type='text/markdown',
    packages=find_packages('src')
)
