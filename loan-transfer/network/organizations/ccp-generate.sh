#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/loanRequester.bank.com/tlsca/tlsca.loanRequester.bank.com-cert.pem
CAPEM=organizations/peerOrganizations/loanRequester.bank.com/ca/ca.loanRequester.bank.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/loanRequester.bank.com/connection-loanRequester.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/loanRequester.bank.com/connection-loanRequester.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/ubi.bank.com/tlsca/tlsca.ubi.bank.com-cert.pem
CAPEM=organizations/peerOrganizations/ubi.bank.com/ca/ca.ubi.bank.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/ubi.bank.com/connection-ubi.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/ubi.bank.com/connection-ubi.yaml

ORG=3
P0PORT=11051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/icici.bank.com/tlsca/tlsca.icici.bank.com-cert.pem
CAPEM=organizations/peerOrganizations/icici.bank.com/ca/ca.icici.bank.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/icici.bank.com/connection-icici.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/icici.bank.com/connection-icici.yaml


ORG=4
P0PORT=21051
CAPORT=21054
PEERPEM=organizations/peerOrganizations/csb.bank.com/tlsca/tlsca.csb.bank.com-cert.pem
CAPEM=organizations/peerOrganizations/csb.bank.com/ca/ca.csb.bank.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/csb.bank.com/connection-csb.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/csb.bank.com/connection-csb.yaml


ORG=5
P0PORT=31051
CAPORT=31054
PEERPEM=organizations/peerOrganizations/regulatorBody.bank.com/tlsca/tlsca.regulatorBody.bank.com-cert.pem
CAPEM=organizations/peerOrganizations/regulatorBody.bank.com/ca/ca.regulatorBody.bank.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulatorBody.bank.com/connection-regulatorBody.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulatorBody.bank.com/connection-regulatorBody.yaml
