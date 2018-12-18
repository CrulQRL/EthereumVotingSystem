FROM ethereum/client-go:v1.8.20

COPY docker/account.txt /account/account.txt
COPY docker/password.txt /account/password.txt
COPY docker/genesis.json /genesis.json
COPY docker/static-nodes.json /static-nodes.json
