#! /usr/bin/env python3

import boto3
import json
from pprint import pprint
import botocore
import subprocess

'''
'''

def getClientVpnEndpointInfo(client):
    '''
    Main function to get Client VPN endpoint info required to invoke getClientVpnConfiguration function
    Returns list of dicts containing each endpoint and association ID.
    '''
    clientVpnEndpointInfo = []
    endpoints = getClientVpnEndpointIds(client)
    for endpoint in endpoints:
        clientVpnEndpointInfo.append(endpoint)
    return clientVpnEndpointInfo

def getClientVpnEndpointIds(client):
    '''
    gets Client VPN Endpoint IDs and returns them as a list.
    '''
    endpoints = []
    r = client.describe_client_vpn_endpoints()
    for entry in r['ClientVpnEndpoints']:
        endpoints.append({entry['Tags'][0]['Value']: entry['ClientVpnEndpointId']})
    return(endpoints)


def getClientVpnConfiguration(client,endpoint):
    for endpoint in endpoints:
        for k,v in endpoint.items():
            response = client.export_client_vpn_client_configuration(
                    ClientVpnEndpointId = v
                    )
#        pprint(response['ClientConfiguration'])
            with open("vpn-config-files/%s.ovpn" % k, "w") as f:
                print("%s" % k[10:13])
                for line in response['ClientConfiguration']:
                    f.write(str(line))

                x = subprocess.Popen("terraform output %s_cert_body" % k[10:13], cwd="./terraform/env/dev", shell=True, stdout=subprocess.PIPE).communicate()[0].decode()
                f.write("\n<cert>\n%s\n</cert>" % str(x).strip("\n"))

                x = subprocess.Popen("terraform output %s_private_key" % k[10:13], cwd="./terraform/env/dev", shell=True, stdout=subprocess.PIPE).communicate()[0].decode()
                f.write("\n<key>\n%s\n</key>" % str(x).strip("\n"))


client=boto3.client('ec2', region_name='us-east-1')
endpoints = getClientVpnEndpointInfo(client)
pprint(endpoints)
getClientVpnConfiguration(client,endpoints)


