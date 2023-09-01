#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/banking.com/tlsca/tlsca.banking.com-cert.pem
export PEER0_REQUESTOR_CA=${PWD}/organizations/peerOrganizations/requestor.banking.com/tlsca/tlsca.requestor.banking.com-cert.pem
export PEER0_AXIS_CA=${PWD}/organizations/peerOrganizations/axis.banking.com/tlsca/tlsca.axis.banking.com-cert.pem
export PEER0_HDFC_CA=${PWD}/organizations/peerOrganizations/hdfc.banking.com/tlsca/tlsca.hdfc.banking.com-cert.pem
export PEER0_SBI_CA=${PWD}/organizations/peerOrganizations/sbi.banking.com/tlsca/tlsca.sbi.banking.com-cert.pem
export PEER0_REGULATOR_CA=${PWD}/organizations/peerOrganizations/regulator.banking.com/tlsca/tlsca.regulator.banking.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/banking.com/orderers/orderer.banking.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/banking.com/orderers/orderer.banking.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG="$1"
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [[ "$USING_ORG" == "requestor" ]]; then
    export CORE_PEER_LOCALMSPID="RequestorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_REQUESTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/requestor.banking.com/users/Admin@requestor.banking.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [[ "$USING_ORG" == "axis" ]]; then
    export CORE_PEER_LOCALMSPID="AxisMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_AXIS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/axis.banking.com/users/Admin@axis.banking.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [[ "$USING_ORG" == "hdfc" ]]; then
    export CORE_PEER_LOCALMSPID="HdfcMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_HDFC_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hdfc.banking.com/users/Admin@hdfc.banking.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
  elif [[ "$USING_ORG" == "sbi" ]]; then
    export CORE_PEER_LOCALMSPID="SbiMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SBI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/sbi.banking.com/users/Admin@sbi.banking.com/msp
    export CORE_PEER_ADDRESS=localhost:7089
  elif [[ "$USING_ORG" == "regulator" ]]; then
    export CORE_PEER_LOCALMSPID="RegulatorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_REGULATOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/regulator.banking.com/users/Admin@regulator.banking.com/msp
    export CORE_PEER_ADDRESS=localhost:11071
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals "$1"

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG="$1"
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [[ "$USING_ORG" == "requestor" ]]; then
    export CORE_PEER_ADDRESS=peer0.requestor.banking.com:7051
  elif [[ "$USING_ORG" == "axis" ]]; then
    export CORE_PEER_ADDRESS=peer0.axis.banking.com:9051
  elif [[ "$USING_ORG" == "hdfc" ]]; then
    export CORE_PEER_ADDRESS=peer0.hdfc.banking.com:11051
  elif [[ "$USING_ORG" == "sbi" ]]; then
    export CORE_PEER_ADDRESS=peer0.sbi.banking.com:7089
  elif [[ "$USING_ORG" == "regulator" ]]; then
    export CORE_PEER_ADDRESS=peer0.regulator.banking.com:11071
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals "$1"
    PEER="peer0.'$1'"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_"$1"_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
