import boto3

def local(infile, outfile):
    # Biztosítja, hogy a kimeneti fájl írása megtörténjen
    outfile.write(infile.read())
    # Fájlok bezárása, ha a művelet kész
    outfile.close()
    infile.close()

client = boto3.client('s3')

def s3(infile, bucket, name):
    # Feltölti a fájlobjektumot az S3-ba
    client.upload_fileobj(infile, bucket, name)
