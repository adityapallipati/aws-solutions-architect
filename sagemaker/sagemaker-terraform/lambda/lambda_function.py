import boto3

def lambda_handler(event, context):
    sagemaker_client = boto3.client('sagemaker')
    ec2_client = boto3.client('ec2')

    # Stop and delete the existing SageMaker Notebook instance
    notebook_instance_name = "sagemaker-notebook-free-tier"
    sagemaker_client.stop_notebook_instance(NotebookInstanceName=notebook_instance_name)
    sagemaker_client.delete_notebook_instance(NotebookInstanceName=notebook_instance_name)

    # Find the latest Amazon Linux AMI
    response = ec2_client.describe_images(
        Filters=[
            {'Name': 'name', 'Values': ['amzn2-ami-hvm-2.0.*-x86_64-gp2']},
            {'Name': 'state', 'Values': ['available']}
        ],
        Owners=['amazon'],
        SortBy='CreationDate',
        SortOrder='desc'
    )

    latest_ami = response['Images'][0]['ImageId']

    # Create a new SageMaker Notebook instance with the latest AMI
    sagemaker_client.create_notebook_instance(
        NotebookInstanceName=notebook_instance_name,
        InstanceType='ml.t2.medium',
        RoleArn='<Your-SageMaker-Execution-Role-ARN>',
        SubnetId='<Your-Subnet-ID>',
        SecurityGroupIds=['<Your-Security-Group-ID>'],
        VolumeSizeInGB=5,
        DirectInternetAccess='Enabled',
        RootAccess='Enabled',
        LifecycleConfigName='sagemaker-lifecycle-config-free-tier'
    )

    return {
        'statusCode': 200,
        'body': f"Notebook instance {notebook_instance_name} refreshed with latest AMI {latest_ami}."
    }