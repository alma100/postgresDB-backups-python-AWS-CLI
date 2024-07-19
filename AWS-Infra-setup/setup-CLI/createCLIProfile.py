import subprocess
import os
from dotenv import load_dotenv

load_dotenv()


aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
aws_default_region = os.getenv('AWS_DEFAULT_REGION')
aws_profile_name = os.getenv('AWS_PROFILE_NAME')

# Configure the AWS CLI profile using subprocess
subprocess.run(['aws', 'configure', 'set', f'profile.{aws_profile_name}.aws_access_key_id', aws_access_key_id])
subprocess.run(['aws', 'configure', 'set', f'profile.{aws_profile_name}.aws_secret_access_key', aws_secret_access_key])
subprocess.run(['aws', 'configure', 'set', f'profile.{aws_profile_name}.region', aws_default_region])

print(f'AWS CLI profile "{aws_profile_name}" created successfully.')