#!/bin/bash

/opt/keycloak/bin/kcadm.sh config credentials --server $KEYCLOAK_URL --realm master --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD

# Enable openfga-events
/opt/keycloak/bin/kcadm.sh update events/config -s 'eventsListeners=["openfga-events-publisher","jboss-logging"]'

# Clients
/opt/keycloak/bin/kcadm.sh create clients -r master  -f - << EOF
  {
    "clientId": "kube-gatekeeper",
    "name": "",
    "description": "",
    "rootUrl": "",
    "adminUrl": "",
    "baseUrl": "",
    "surrogateAuthRequired": false,
    "enabled": true,
    "alwaysDisplayInConsole": false,
    "clientAuthenticatorType": "client-secret",
    "redirectUris": [
        "http://localhost:18000",
        "http://localhost:8000"
    ],
    "webOrigins": [
        "http://localhost:18000",
        "http://localhost:8000"
    ],
    "notBefore": 0,
    "bearerOnly": false,
    "consentRequired": false,
    "standardFlowEnabled": true,
    "implicitFlowEnabled": false,
    "directAccessGrantsEnabled": true,
    "serviceAccountsEnabled": false,
    "publicClient": true,
    "frontchannelLogout": true,
    "protocol": "openid-connect",
    "attributes": {
        "oidc.ciba.grant.enabled": "false",
        "oauth2.device.authorization.grant.enabled": "false",
        "backchannel.logout.session.required": "true",
        "backchannel.logout.revoke.offline.tokens": "false"
    },
    "authenticationFlowBindingOverrides": {},
    "fullScopeAllowed": true,
    "nodeReRegistrationTimeout": -1,
    "defaultClientScopes": [
        "web-origins",
        "acr",
        "profile",
        "roles",
        "email"
    ],
    "optionalClientScopes": [
        "address",
        "phone",
        "offline_access",
        "microprofile-jwt"
    ],
    "access": {
        "view": true,
        "configure": true,
        "manage": true
    }
  }
EOF

# Users
/opt/keycloak/bin/kcadm.sh create users -r master -s username=jon.whitaker@okta.com -s enabled=true
/opt/keycloak/bin/kcadm.sh set-password -r master --username jon.whitaker@okta.com --new-password password

# /opt/keycloak/bin/kcadm.sh create users -r master -s username=andres.aguiar@okta.com -s enabled=true
# /opt/keycloak/bin/kcadm.sh set-password -r master --username andres.aguiar@okta.com --new-password password


# Groups
/opt/keycloak/bin/kcadm.sh create groups -r master -s name=fga-backend
#/opt/keycloak/bin/kcadm.sh create groups -r master -s name=fga-frontend
