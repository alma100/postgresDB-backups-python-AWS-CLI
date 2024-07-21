import boto3

session = boto3.Session(profile_name='terraProfile')
ec2_client = session.client('ec2')
ssm_client = session.client('ssm')

def get_instance_id():
    response = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': ['database']
            },
            {
                'Name': 'instance-state-name',
                'Values': ['running']
            }
        ]
    )
    
    print([response['Reservations'][0]['Instances'][0]['InstanceId']])

    return [response['Reservations'][0]['Instances'][0]['InstanceId']]

instance_ids = get_instance_id()

script_content = '''
#!/bin/bash
curl -O https://raw.githubusercontent.com/alma100/postgresDB-backups-python-AWS-CLI/main/AWS-Infra-setup/db-setup/seed-database.sh
chmod +x seed-database.sh
./seed-database.sh
'''

# SSM parancs küldése az EC2 példányokra
response = ssm_client.send_command(
    InstanceIds=instance_ids,
    DocumentName='AWS-RunShellScript',
    Parameters={'commands': [script_content]},
    Comment='Run db seed script from github'
)

print(response)

