# postgresDB-backups-python-AWS-CLI




## Prerequisites:

- python (3.12.3 or later) and pip ( 24.1.2 or later)
- Pipenv or other python virtualenviroment package

## Set up project:

- `git clone git@github.com:alma100/postgresDB-backups-python-AWS-CLI.git`
- `cd postgresDB-backups-python-AWS-CLI`
- `pipenv shell`
- `pipenv install -r requirements.txt`
- `cd AWS-Infra-setup/setup-CLI`
- create .env file.
  - add these variables:
    - AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
    - AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
    - AWS_DEFAULT_REGION=<region>
    - AWS_PROFILE_NAME=terraProfile
- `python createCLIProfile.py`
- `cd ..`
- Add your public ssh key to the sshKey.tf
- `terraform inti`
- `terraform apply` after tf project start running, you shold apply the process, type it `yes`

If you need some random data:
- After ec2 ready, ssh into the instance and run this command: `curl -O https://raw.githubusercontent.com/alma100/postgresDB-backups-python-AWS-CLI/main/AWS-Infra-setup/db-setup/seed-database.sh`
- `chmod +x seed-database.sh`
- `./seed-database.sh`
