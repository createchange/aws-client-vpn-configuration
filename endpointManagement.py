#! /usr/bin/env python3

import boto3
import json
from pprint import pprint
import botocore
import sys,argparse

'''
To Do:
    - Check current status of Endpoint Association: if pending-associate / disassociating, don't pass to diassociate function.
    - Create function to associate all Client VPNs with the appropriate subnet.
'''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Init argparse
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
class MyParser(argparse.ArgumentParser):
    def error(self, message):
        sys.stderr.write('error: %s\n' % message)
        self.print_help()
        sys.exit(2)

description = "This script lets you associate and disassociate Client VPN Endpoints"
#parser = argparse.ArgumentParser(description = description)
parser = MyParser(description = description)
parser.add_argument("-a", "--associate", help="associates all Client VPN Endpoints", action="store_true")
parser.add_argument("-d", "--disassociate", help="disassociates all Client VPN Endpoints", action="store_true")
args = parser.parse_args()


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Functions
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

def getClientVpnSubnet(client):
    '''
    Gets subnet with "ClientVPN":"true" key pair
    '''
    r = client.describe_subnets(
            Filters =[
                {
                    'Name': 'tag:ClientVPN',
                    'Values': [
                        'true',
                    ]
                },
            ]
        )

    return r['Subnets'][0]['SubnetId']

def getClientVpnEndpointIds(client):
    '''
    gets Client VPN Endpoint IDs and returns them as a list.
    '''
    endpoints = []
    r = client.describe_client_vpn_endpoints()
    for entry in r['ClientVpnEndpoints']:
        endpoints.append(entry['ClientVpnEndpointId'])
    return(endpoints)


def getClientVpnTargetNetworks(client,endpoint):
    '''
    Takes EndpointId as input, and gets AssociationId to pass to disassociateClientVpnEndpoint function.
    Returns dict of k: EndpointId, v: AssociationId
    '''
    r = client.describe_client_vpn_target_networks(
            ClientVpnEndpointId = endpoint
        )
    if r['ClientVpnTargetNetworks']:
        return {endpoint: r['ClientVpnTargetNetworks'][0]['AssociationId']}
    else:
        return {endpoint: None}

def getClientVpnEndpointInfo(client):
    '''
    Main function to get Client VPN endpoint info required to invoke disassociateClientVpnEndpoint function.
    Returns list of dicts containing each endpoint and association ID.
    '''
    clientVpnEndpointInfo = []
    endpoints = getClientVpnEndpointIds(client)
    for endpoint in endpoints:
        endpointInfo = getClientVpnTargetNetworks(client,endpoint)
        clientVpnEndpointInfo.append(endpointInfo)
    return clientVpnEndpointInfo
    
def disassociateClientVpnEndpoint(client,endpointInfo):
    '''
    Function to kill associations for all Client VPNs.
    '''
    for endpointId, AssociationId in endpointInfo.items():
        try:
            response = client.disassociate_client_vpn_target_network(
                    ClientVpnEndpointId = endpointId,
                    AssociationId = AssociationId
            )
        except botocore.exceptions.ParamValidationError:
            print('not associated')

def associateClientVpnEndpoints(client,endpoint,clientVpnSubnet):
    '''
    Function to associate Client VPN endpoint with apppropriate subnet.
    '''
    for k,v in endpoint.items():
        response = client.associate_client_vpn_target_network(
            ClientVpnEndpointId= k,
            SubnetId=clientVpnSubnet,
        )

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Start main script
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
client=boto3.client('ec2', region_name='us-east-1')

if args.associate:
    clientVpnSubnet = getClientVpnSubnet(client)
    clientVpnEndpointInfo = getClientVpnEndpointInfo(client)
    for endpoint in clientVpnEndpointInfo:
        associateClientVpnEndpoints(client,endpoint,clientVpnSubnet)

if args.disassociate:
    clientVpnEndpointInfo = getClientVpnEndpointInfo(client)
    for endpoint in clientVpnEndpointInfo:
        disassociateClientVpnEndpoint(client,endpoint)

if len(sys.argv) == 1:
    parser.print_help()
    sys.exit(1)
