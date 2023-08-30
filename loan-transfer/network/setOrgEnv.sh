#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using Org1
ORG=${1:-Org1}

# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/test-network/organizations/ordererOrganizations/bank.com/tlsca/tlsca.bank.com-cert.pem
PEER0_ORG1_CA=${DIR}/test-network/organizations/peerOrganizations/loanRequester.bank.com/tlsca/tlsca.loanRequester.bank.com-cert.pem
PEER0_ORG2_CA=${DIR}/test-network/organizations/peerOrganizations/ubi.bank.com/tlsca/tlsca.ubi.bank.com-cert.pem
PEER0_ORG3_CA=${DIR}/test-network/organizations/peerOrganizations/icici.bank.com/tlsca/tlsca.icici.bank.com-cert.pem
PEER0_ORG4_CA=${DIR}/test-network/organizations/peerOrganizations/csb.bank.com/tlsca/tlsca.csb.bank.com-cert.pem
PEER0_ORG5_CA=${DIR}/test-network/organizations/peerOrganizations/regulatorBody.bank.com/tlsca/tlsca.regulatorBody.bank.com-cert.pem


if [[ ${ORG,,} == "loanRequester" || ${ORG,,} == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=Org1MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/loanRequester.bank.com/users/Admin@loanRequester.bank.com/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/loanRequester.bank.com/tlsca/tlsca.loanRequester.bank.com-cert.pem

elif [[ ${ORG,,} == "ubi" || ${ORG,,} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=Org2MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/ubi.bank.com/users/Admin@ubi.bank.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/ubi.bank.com/tlsca/tlsca.ubi.bank.com-cert.pem

elif [[ ${ORG,,} == "icici" || ${ORG,,} == "digicorp" ]]; then

   CORE_PEER_LOCALMSPID=Org3MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/icici.bank.com/users/Admin@icici.bank.com/msp
   CORE_PEER_ADDRESS=localhost:11051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/icici.bank.com/tlsca/tlsca.icici.bank.com-cert.pem

elif [[ ${ORG,,} == "csb" || ${ORG,,} == "digicorp" ]]; then

   CORE_PEER_LOCALMSPID=Org4MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/csb.bank.com/users/Admin@csb.bank.com/msp
   CORE_PEER_ADDRESS=localhost:21051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/csb.bank.com/tlsca/tlsca.csb.bank.com-cert.pem


elif [[ ${ORG,,} == "regulatorBody" || ${ORG,,} == "digicorp" ]]; then

   CORE_PEER_LOCALMSPID=Org5MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/regulatorBody.bank.com/users/Admin@regulatorBody.bank.com/msp
   CORE_PEER_ADDRESS=localhost:31051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/regulatorBody.bank.com/tlsca/tlsca.regulatorBody.bank.com-cert.pem


else
   echo "Unknown \"$ORG\", please choose Org1/Digibank or Org2/Magnetocorp"
   echo "For bank to get the environment variables to set upa Org2 shell environment run:  ./setOrgEnv.sh Org2"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Org2 | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_ORG1_CA=${PEER0_ORG1_CA}"
echo "PEER0_ORG2_CA=${PEER0_ORG2_CA}"
echo "PEER0_ORG3_CA=${PEER0_ORG3_CA}"
echo "PEER0_ORG4_CA=${PEER0_ORG4_CA}"
echo "PEER0_ORG5_CA=${PEER0_ORG5_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
