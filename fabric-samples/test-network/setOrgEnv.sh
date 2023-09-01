#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using Requestor
ORG="${1:-"requestor"}"

# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/test-network/organizations/ordererOrganizations/banking.com/tlsca/tlsca.banking.com-cert.pem
PEER0_REQUESTOR_CA=${DIR}/test-network/organizations/peerOrganizations/requestor.banking.com/tlsca/tlsca.requestor.banking.com-cert.pem
PEER0_AXIS_CA=${DIR}/test-network/organizations/peerOrganizations/axis.banking.com/tlsca/tlsca.axis.banking.com-cert.pem
PEER0_HDFC_CA=${DIR}/test-network/organizations/peerOrganizations/hdfc.banking.com/tlsca/tlsca.hdfc.banking.com-cert.pem
PEER0_SBI_CA=${DIR}/test-network/organizations/peerOrganizations/sbi.banking.com/tlsca/tlsca.sbi.banking.com-cert.pem
PEER0_REGULATOR_CA=${DIR}/test-network/organizations/peerOrganizations/regulator.banking.com/tlsca/tlsca.regulator.banking.com-cert.pem


if [[ "${ORG,,}" == "requestor" || "${ORG,,}" == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=RequestorMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/requestor.banking.com/users/Admin@requestor.banking.com/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/requestor.banking.com/tlsca/tlsca.requestor.banking.com-cert.pem

elif [[ "${ORG,,}" == "axis" || "${ORG,,}" == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=AxisMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/axis.banking.com/users/Admin@axis.banking.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/axis.banking.com/tlsca/tlsca.axis.banking.com-cert.pem

elif [[ "${ORG,,}" == "hdfc" ]]; then

   CORE_PEER_LOCALMSPID=HdfcMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/hdfc.banking.com/users/Admin@hdfc.banking.com/msp
   CORE_PEER_ADDRESS=localhost:11051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/hdfc.banking.com/tlsca/tlsca.hdfc.banking.com-cert.pem

elif [[ "${ORG,,}" == "sbi" ]]; then

   CORE_PEER_LOCALMSPID=SbiMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/sbi.banking.com/users/Admin@sbi.banking.com/msp
   CORE_PEER_ADDRESS=localhost:7089
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/sbi.banking.com/tlsca/tlsca.sbi.banking.com-cert.pem

elif [[ "${ORG,,}" == "regulator" ]]; then

   CORE_PEER_LOCALMSPID=RegulatorMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/regulator.banking.com/users/Admin@regulator.banking.com/msp
   CORE_PEER_ADDRESS=localhost:11071
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/regulator.banking.com/tlsca/tlsca.regulator.banking.com-cert.pem

else
   echo "Unknown \"$ORG\", please choose Requestor/Digibank or Axis/Magnetocorp"
   echo "For example to get the environment variables to set upa Axis shell environment run:  ./setOrgEnv.sh Axis"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Axis | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_REQUESTOR_CA=${PEER0_REQUESTOR_CA}"
echo "PEER0_AXIS_CA=${PEER0_AXIS_CA}"
echo "PEER0_HDFC_CA=${PEER0_HDFC_CA}"
echo "PEER0_SBI_CA=${PEER0_SBI_CA}"
echo "PEER0_REGULATOR_CA=${PEER0_REGULATOR_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
