

def local(infile, outfile):
    # Biztosítja, hogy a kimeneti fájl írása megtörténjen
    outfile.write(infile.read())
    # Fájlok bezárása, ha a művelet kész
    outfile.close()
    infile.close()


def s3(client, infile, bucket, name):
    # Feltölti a fájlobjektumot az S3-ba
    client.upload_fileobj(infile, bucket, name)


